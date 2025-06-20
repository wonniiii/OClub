//
//  LoginView.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import SwiftUI

struct LaunchView: View {
    @EnvironmentObject private var router: NavigationRouter
    @StateObject private var viewModel: LaunchViewModel

    init() {
        #if targetEnvironment(simulator)
        let repo: SSORepositoryProtocol = DummySSORepository()
        #else
        let repo: SSORepositoryProtocol = SSORepository()
        #endif

        _viewModel = StateObject(
            wrappedValue: LaunchViewModel(
                authUseCase: AuthenticateUserUseCase(repository: repo),
                appID: "NC00000015"
            )
        )
    }

    var body: some View {
        VStack(spacing: 12) {
            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(height: 220)
                .padding(.horizontal, 70)

            Image("onsLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 30)
                .padding(.top, 30)

            ProgressView("인증 확인 중...")
                .padding(.top, 20)
        }
        .onAppear {
            viewModel.setRouter(router)
            viewModel.onAppear {
                router.push(.main)
            }
        }
        .alert("Smart.CJ 설치가 필요합니다.", isPresented: $viewModel.showInstallAlert) {
            Button("확인", action: viewModel.handleInstallConfirmed)
        }
        .alert("Smart.CJ 로그인이 필요합니다.", isPresented: $viewModel.showLoginAlert) {
            Button("확인", action: viewModel.handleLoginConfirmed)
        }
    }
}
