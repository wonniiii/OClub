//
//  MainView.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var router: NavigationRouter
    @StateObject private var viewModel: MainViewModel
    @AppStorage("cjUserIDOnly") private var storedUserID: String = ""
    let userInfo: UserInfo
    
    init(userInfo: UserInfo) {
        _viewModel = StateObject(wrappedValue: MainViewModel(userID: userInfo.userID.cjUserIDOnly))
        self.userInfo = userInfo
    }
    
    var body: some View {
        ZStack(alignment: .leading) {
            Color.allBackground
                .ignoresSafeArea()
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 4) {
//                    Text("안녕하세요 \(userInfo.userID.cjUserIDOnly)님 🙌")
                    Text("안녕하세요 sim7480님 🙌")
                        .font(.PCallout)
                    Text("사내 동호회 O'Club")
                        .font(.PTitle1).bold()
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                                
                ScrollView(showsIndicators: false) {
                    LazyVStack(spacing: 28) {
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, minHeight: 300)
                        } else {
                            ForEach(Array(viewModel.clubs.enumerated()), id: \.offset) { index, club in
                                CardContainerView(
                                    desiredColor: index == 0 ? .cjRed : .cjYellow,
                                    onOverlayTap: {
                                        router.push(.board(club: club))
                                    },
                                    content: {
                                        MainCardContentView(
                                            club: club,
                                            userInfo: userInfo,
                                            latestPostDate: viewModel.latestPostDate(for: club.id),
                                            nextMeetingDate: viewModel.nextUpcomingScheduleDate(for: club.id)
                                        )
                                    }
                                )
                            }
                        }
                    }
                }
            }
        }
        
        .onAppear {
            viewModel.fetchUserClubs()
            storedUserID = userInfo.userID.cjUserIDOnly.lowercased()
        }
        
    }
}

extension String {
    var cjUserIDOnly: String {
        return self.components(separatedBy: "$").first ?? self
    }
}
