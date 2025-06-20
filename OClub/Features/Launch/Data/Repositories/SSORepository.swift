//
//  SSORepository.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/23/25.
//

protocol SSORepositoryProtocol {
    func getAppInfo(appID: String) -> [String: Any]?
    func isSmartInstalled() -> Bool
    func runSmartInstall()
    func runLogin(appID: String)
}

#if targetEnvironment(simulator)

final class DummySSORepository: SSORepositoryProtocol {
    func getAppInfo(appID: String) -> [String: Any]? {
        return [
            "AppID": "SIM_APP_ID",
            "AppVersion": "1.0.0",
            "LoginDT": "2025-01-01 12:00",
            "LoginYN": "Y",
            "UserID": "testUser$2025-01-01 12:00"
        ]
    }

    func isSmartInstalled() -> Bool { true }
    func runSmartInstall() {}
    func runLogin(appID: String) {}
}

#else

final class SSORepository: SSORepositoryProtocol {
    private let sso = SSO()

    func getAppInfo(appID: String) -> [String: Any]? {
        return sso.getAppInfo(appID) as? [String: Any]
    }

    func isSmartInstalled() -> Bool {
        return sso.getIsInstallSmartCJ()
    }

    func runSmartInstall() {
        sso.runSmartCJInstall()
    }

    func runLogin(appID: String) {
        sso.runCJLogin(appID)
    }
}

#endif
