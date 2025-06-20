//
//  ContentView.swift
//  O'Club
//
//  Created by 최효원 on 4/8/25.
//

import SwiftUI

struct ContentView: View {
    let userInfo: UserInfo
    @State private var clubs: [Club] = []
    @AppStorage("cjUserIDOnly") private var storedUserID: String = ""

    var body: some View {
        TabView {
            MainView(userInfo: userInfo)
                .tabItem {
                    Image(systemName: "house")
                    Text("홈")
                }

            ScheduleView(clubs: clubs, storedUserID: storedUserID)
                .tabItem {
                    Image(systemName: "calendar")
                    Text("일정")
                }

            IntroductionView(viewModel: ClubViewModel(
                fetchUseCase: FetchClubsUseCase(repository: ClubRepository())
            ))
            .tabItem {
                Image(systemName: "person.3")
                Text("소개")
            }

            FAQView()
                .tabItem {
                    Image(systemName: "questionmark.circle")
                    Text("FAQ")
                }
        }
        .onAppear {
            loadUserClubs()
        }
    }

    private func loadUserClubs() {
        Task {
            do {
                let user = try await UserRepository().fetchUser(userID: "sim7480")
                let fetched = try await ClubRepository().fetchClubsByIDs(user.clubs.map { String($0) })
                clubs = fetched
            } catch {
                print("❌ 클럽 로딩 실패: \(error)")
            }
        }
    }
}
