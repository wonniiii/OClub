//
//  AddScheduleViewModel.swift
//  O'Club
//
//  Created by 최효원 on 4/15/25.
//

import SwiftUI

@MainActor
final class AddScheduleViewModel: ObservableObject {
    // MARK: - Input Fields
    @Published var title: String = ""
    @Published var date: Date = Date()
    @Published var place: String = ""
    @Published var startTime: Date = Date()
    @Published var endTime: Date = Date()
    @Published var selectedClub: Club?
    
    // MARK: - Dependencies
    private let addUseCase: AddScheduleUseCaseProtocol
    
    // MARK: - Init
    init(addUseCase: AddScheduleUseCaseProtocol) {
        self.addUseCase = addUseCase
    }
    
    // MARK: - Add Action
    /// 일정 추가 버튼 액션
    func add(completion: @escaping (Result<Void, Error>) -> Void) {
        guard let club = selectedClub else {
            completion(.failure(NSError(
                domain: "AddSchedule",
                code: 0,
                userInfo: [NSLocalizedDescriptionKey: "클럽을 선택하세요"]
            )))
            return
        }
        let newSchedule = Schedule(
            name: title,
            date: date,
            startTime: startTime,
            endTime: endTime,
            location: place,
            participants: [],
            clubID: club.id,
            clubName: club.name
        )
        Task {
            do {
                try await addUseCase.execute(newSchedule)
                // 1) 새로운 일정 등록 즉시 알림
                NotificationManager.shared.scheduleNewScheduleAlert(for: newSchedule)
                // 2) 일정 당일 아침 9시 알림
                NotificationManager.shared.scheduleMorningReminder(for: newSchedule)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
