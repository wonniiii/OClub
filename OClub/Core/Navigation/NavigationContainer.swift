//
//  NavigationContainer.swift
//  O'Club
//
//  Created by 최효원 on 4/14/25.
//

import SwiftUI

struct NavigationContainer<Content: View>: View {
    @StateObject private var router = NavigationRouter()
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .main:
                        if let userInfo = router.userInfo {
                            ContentView(userInfo: userInfo)
                                .toolbar(.hidden)
                        }
                    case .board(let club):
                        BoardView(club: club)
                            .toolbar(.hidden)
                    case .boardDetail(let clubID, let post):
                        BoardDetailView(post: post, clubID: clubID)
                            .toolbar(.hidden)
                    case .participants(let schedule, let club):
                        ParticipantsView(schedule: schedule, club: club)
                            .toolbar(.hidden)
                    case .introDetail(let club):
                        let repository = ClubRepository()
                        let useCase = UpdateClubIntroUseCase(repository: repository)
                        let viewModel = ClubDetailViewModel(club: club)
                        
                        IntroductionDetailView(
                            viewModel: viewModel,
                            useCase: useCase
                        )
                        .toolbar(.hidden)
                        
                    case .reportList:
                        MonthlyReportView()
                            .toolbar(.hidden)
                    case .reportDetail:
                        ReportDetailView()
                            .toolbar(.hidden)
                    case .faqDetail(let type):
                        let remote = MainFAQDummyDataSource()
                        let repo = FAQRepositoryImpl(remote: remote)
                        let useCase = GetMainFAQDetailUseCase(repository: repo)
                        let viewModel = MainFAQDetailViewModel(useCase: useCase)
                        MainFAQDetailView(viewModel: viewModel, type: type)
                            .toolbar(.hidden)
                    case .writeReport:
                        WriteReportView()
                            .toolbar(.hidden)
                        
                    }
                }
        }
        .environmentObject(router)
    }
}
