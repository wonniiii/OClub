//
//  MainViewModel.swift
//  O'Club
//
//  Created by 최효원 on 4/10/25.
//

import SwiftUI
import Combine

@MainActor
final class MainViewModel: ObservableObject {
    @Published var clubs: [Club] = []
    @Published var clubPostsMap: [String: [Post]] = [:]
    @Published var isLoading = false
    @AppStorage("cjUserIDOnly") private var storedUserID: String = ""
    @Published var clubSchedulesMap: [String: [Schedule]] = [:]
    
    private let clubRepository: ClubRepositoryProtocol
    private let userRepository: UserRepositoryProtocol
    private let postUseCase: FetchPostsUseCaseProtocol
    private let scheduleUseCase: FetchScheduleUseCaseProtocol
    private var cancellables = Set<AnyCancellable>()
    private let userID: String
    
    init(userID: String,
         clubRepository: ClubRepositoryProtocol = ClubRepository(),
         userRepository: UserRepositoryProtocol = UserRepository(),
         postUseCase: FetchPostsUseCaseProtocol = FetchPostsUseCase(repository: DefaultPostRepository()),
         scheduleUseCase: FetchScheduleUseCaseProtocol = FetchScheduleUseCase(repository: ScheduleRepository())
    ) {
        self.userID = userID
        self.clubRepository = clubRepository
        self.userRepository = userRepository
        self.postUseCase = postUseCase
        self.scheduleUseCase = scheduleUseCase
    }
    
    func fetchUserClubs() {
        isLoading = true
        
        Task {
            do {
                let user = try await userRepository.fetchUser(userID: "sim7480")
                let clubIDs = user.clubs
                
                clubRepository.fetchClubs { [weak self] result in
                    guard let self else { return }
                    
                    switch result {
                    case .success(let allClubs):
                        self.clubs = allClubs.filter { Int($0.id).map { clubIDs.contains($0) } ?? false }
                        for club in self.clubs {
                            Task {
                                await self.fetchPosts(for: club.id)
                                await self.fetchSchedules(for: club.id)
                            }
                        }
                    case .failure(let error):
                        print("Error fetching clubs: \(error)")
                    }
                    
                    self.isLoading = false
                }
                
            } catch {
                print("Error fetching user info: \(error)")
                isLoading = false
            }
        }
    }
    private func fetchPosts(for clubID: String) async {
        do {
            let posts = try await postUseCase.execute(clubID: clubID)
            await MainActor.run {
                self.clubPostsMap[clubID] = posts
            }
        } catch {
            print("❌ 게시글 로딩 실패 - \(clubID): \(error)")
        }
    }
    
    func latestPostDate(for clubID: String) -> Date? {
        return clubPostsMap[clubID]?.sorted(by: { $0.createdAt > $1.createdAt }).first?.createdAt
        
    }
    
    func fetchSchedules(for clubID: String) async {
        do {
            let schedules = try await scheduleUseCase.execute(clubID: clubID)
            await MainActor.run {
                self.clubSchedulesMap[clubID] = schedules
            }
        } catch {
            print("❌ 스케줄 로딩 실패 - \(clubID): \(error)")
        }
    }
    
    func nextUpcomingScheduleDate(for clubID: String) -> Date? {
        let now = Date()
        return clubSchedulesMap[clubID]?
            .map { $0.date }
            .filter { $0 > now }
            .sorted()
            .first
    }
}
