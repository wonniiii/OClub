//
//  ScheduleViewModel.swift
//  O'Club
//
//  Created by 최효원 on 4/15/25.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class ScheduleViewModel: ObservableObject {
    /// 현재 로그인한 사용자 ID
    let currentUserID: String
    /// 앱 시작 시 전달된 클럽 목록 (ID→클럽 매핑에 사용)
    private let clubs: [Club]

    @Published private(set) var schedules: [Schedule] = []
    @Published var selectedDate: Date = Date()
    @Published var calendarMonth: Date = Date()
    @Published var isShowingSheet: Bool = false

    private let fetchUseCase: FetchScheduleUseCaseProtocol
    private let deleteUseCase: DeleteScheduleUseCaseProtocol
    private let updateParticipantUseCase: UpdateParticipantUseCaseProtocol
    private var listeners: [ListenerRegistration] = []

    init(
        currentUserID: String,
        clubs: [Club],
        fetchUseCase: FetchScheduleUseCaseProtocol,
        deleteUseCase: DeleteScheduleUseCaseProtocol,
        updateParticipantUseCase: UpdateParticipantUseCaseProtocol
    ) {
        self.currentUserID = currentUserID
        self.clubs = clubs
        self.deleteUseCase = deleteUseCase
        self.fetchUseCase = fetchUseCase
        self.updateParticipantUseCase = updateParticipantUseCase

        Task { await loadSchedules() }
        startListening()
    }

    deinit {
        listeners.forEach { $0.remove() }
    }

    private func loadSchedules() async {
        do {
            var all: [Schedule] = []
            for club in clubs {
                let list = try await fetchUseCase.execute(clubID: club.id)
                let mapped = list.map { schedule -> Schedule in
                    var schedule = schedule
                    schedule.clubID = club.id
                    schedule.clubName = club.name
                    return schedule
                }
                all.append(contentsOf: mapped)
            }
            schedules = all
        } catch {
            print("❌ 스케줄 로드 실패:", error)
        }
    }

    private func startListening() {
        for club in clubs {
            let registration = fetchUseCase.observe(clubID: club.id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let list):
                    DispatchQueue.main.async {
                        for var schedule in list {
                            schedule.clubID = club.id
                            schedule.clubName = club.name
                            if let idx = self.schedules.firstIndex(where: { $0.id == schedule.id }) {
                                self.schedules[idx] = schedule
                            } else {
                                self.schedules.append(schedule)
                            }
                        }
                    }
                case .failure(let error):
                    print("❌ 리스너 에러:", error)
                }
            }
            listeners.append(registration)
        }
    }

    var filteredSchedules: [Schedule] {
        schedules.filter {
            Calendar.current.isDate($0.date, inSameDayAs: selectedDate)
        }
    }

    var filteredSchedulesBinding: [Binding<Schedule>] {
        schedules.compactMap { schedule in
            guard Calendar.current.isDate(schedule.date, inSameDayAs: selectedDate),
                  let id = schedule.id else { return nil }
            return Binding<Schedule>(
                get: {
                    guard let index = self.schedules.firstIndex(where: { $0.id == id }) else {
                        fatalError("Schedule disappeared from list.")
                    }
                    return self.schedules[index]
                },
                set: { newValue in
                    guard let index = self.schedules.firstIndex(where: { $0.id == id }) else { return }
                    self.schedules[index] = newValue
                }
            )
        }
    }

    // MARK: - Toggle Attendance
    func toggleAttendance(schedule: Schedule, isOn: Bool) {
        Task {
            do {
                if isOn {
                    try await updateParticipantUseCase.add(
                        userID: currentUserID,
                        to: schedule.id!,
                        in: schedule.clubID
                    )
                } else {
                    try await updateParticipantUseCase.remove(
                        userID: currentUserID,
                        from: schedule.id!,
                        in: schedule.clubID
                    )
                }
            } catch {
                print("❌ 참석 토글 에러:", error)
            }
        }
    }
    
    func deleteSchedule(_ schedule: Schedule) async {
        guard let scheduleID = schedule.id else { return }

        do {
            try await deleteUseCase.execute(clubID: schedule.clubID, scheduleID: scheduleID)
            await MainActor.run {
                self.schedules.removeAll { $0.id == scheduleID }
            }
        } catch {
            print("❌ 일정 삭제 실패: \(error)")
        }
    }
}
