//
//  NotificationManager.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 5/12/25.
//

import Foundation
import UserNotifications

final class NotificationManager {
    static let shared = NotificationManager()
    private init() {}

    func requestAuthorization() async throws {
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        let granted = try await center.requestAuthorization(options: options)
        guard granted else {
            throw NSError(domain: "Notifications", code: 1, userInfo: [NSLocalizedDescriptionKey: "알림 권한이 거부되었습니다."])
        }
    }

    func scheduleNewScheduleAlert(for schedule: Schedule) {
        let content = UNMutableNotificationContent()
        content.title = "새로운 일정 등록"
        content.body  = "[\(schedule.clubName)]의 새로운 일정이 등록되었습니다."
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(
            identifier: "newSchedule-\(String(describing: schedule.id?.description))",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ newSchedule 알림 스케줄링 실패:", error)
            }
            debugPrintPendingNotifications()

        }
    }

    func scheduleMorningReminder(for schedule: Schedule) {
        let content = UNMutableNotificationContent()
        content.title = "오늘 일정 알림"
        content.body  = "[\(schedule.clubName)] \(schedule.name)가 오늘 \(schedule.startTime.timeSliceFormattedString)에 시작됩니다."
        content.sound = .default

//        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: schedule.date)
//        dateComponents.hour = 10
//        dateComponents.minute = 19
        
        let testDate = Calendar.current.date(byAdding: .minute, value: 1, to: Date())!
        let dateComponents = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: testDate
        )

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(
            identifier: "morningReminder-\(String(describing: schedule.id?.description))",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ morningReminder 알림 스케줄링 실패:", error)
            }
            debugPrintPendingNotifications()
        }
    }

    func cancelNotifications(for scheduleID: String) {
        let ids = ["newSchedule-\(scheduleID)", "morningReminder-\(scheduleID)"]
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
}

/// 디버깅용: 현재 대기 중인 알림 식별자 출력
func debugPrintPendingNotifications() {
    UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
        let ids = requests.map(\.identifier)
        print("🔔 Pending notifications:", ids)
    }
}
