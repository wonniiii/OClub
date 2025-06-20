//
//  O_ClubApp.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import UIKit
import SwiftUI
import FirebaseCore
import FirebaseFirestore
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        // 시뮬레이터 영속성 제거
        let settings = FirestoreSettings()
        settings.cacheSettings = MemoryCacheSettings()
        let database = Firestore.firestore()
        database.settings = settings
        
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        
        return true
    }
    
    // 앱이 포그라운드일 때도 알림 배너 보여주기
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.banner, .sound])
    }
}

@main
struct O_ClubApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
        Task {
            do {
                try await NotificationManager.shared.requestAuthorization()
            } catch {
                print("알림 권한 요청 실패:", error)
            }
            let settings = await UNUserNotificationCenter.current().notificationSettings()
            print("🔔 Notification settings:", settings.authorizationStatus)
        }
    }

    var body: some Scene {
        WindowGroup {
            NavigationContainer {
                LaunchView()
            }
        }
    }
}
