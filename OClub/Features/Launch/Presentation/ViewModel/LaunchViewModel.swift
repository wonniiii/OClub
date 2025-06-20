//
//  LaunchViewModel.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/23/25.
//

import SwiftUI

@MainActor
final class LaunchViewModel: ObservableObject {
    @Published var userInfo: UserInfo?
    @Published var showInstallAlert = false
    @Published var showLoginAlert = false
    @Published var isLoading = true

    private let authUseCase: AuthenticateUserUseCase
    private let appID: String
    private var router: NavigationRouter?

    init(authUseCase: AuthenticateUserUseCase, appID: String) {
        self.authUseCase = authUseCase
        self.appID = appID
    }

    func setRouter(_ router: NavigationRouter) {
        self.router = router
    }

    func onAppear(onSuccess: @escaping () -> Void) {
        authUseCase.execute(appID: appID) { result in
            switch result {
            case .success(let user):
                self.userInfo = user
                self.router?.userInfo = user
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    onSuccess()
                }
            case .failure(let error):
                switch error {
                case .needInstall:
                    self.showInstallAlert = true
                case .needLogin:
                    self.showLoginAlert = true
                default:
                    break
                }
            }
        }
    }

    func handleInstallConfirmed() {
        authUseCase.install()
    }

    func handleLoginConfirmed() {
        authUseCase.login(appID: appID)
    }
}
