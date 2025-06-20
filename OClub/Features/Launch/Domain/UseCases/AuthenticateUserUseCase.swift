//
//  AuthenticateUserUseCase.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/23/25.
//

final class AuthenticateUserUseCase {
    private let repository: SSORepositoryProtocol

    init(repository: SSORepositoryProtocol) {
        self.repository = repository
    }

    func execute(appID: String, completion: @escaping (Result<UserInfo, SSOError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard self.repository.isSmartInstalled() else {
                DispatchQueue.main.async {
                    completion(.failure(.needInstall))
                }
                return
            }

            guard let info = self.repository.getAppInfo(appID: appID) else {
                DispatchQueue.main.async {
                    completion(.failure(.failedToGetInfo))
                }
                return
            }

            guard let loginYN = info["LoginYN"] as? String else {
                DispatchQueue.main.async {
                    completion(.failure(.failedToGetInfo))
                }
                return
            }

            if loginYN == "N" {
                DispatchQueue.main.async {
                    completion(.failure(.needLogin))
                }
                return
            }

            let userInfo = UserInfo(
                appID: info["AppID"] as? String ?? "",
                appVersion: info["AppVersion"] as? String ?? "",
                loginDate: info["LoginDT"] as? String ?? "",
                isLoggedIn: true,
                userID: info["UserID"] as? String ?? ""
            )

            DispatchQueue.main.async {
                completion(.success(userInfo))
            }
        }
    }

    func install() {
        DispatchQueue.main.async {
            self.repository.runSmartInstall()
        }
    }

    func login(appID: String) {
        DispatchQueue.main.async {
            print("[Login Triggered] runLogin called on main thread ✅")
            self.repository.runLogin(appID: appID)
        }
    }
}
