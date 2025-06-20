//
//  D.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 5/15/25.
//

protocol DeleteScheduleUseCaseProtocol {
    func execute(clubID: String, scheduleID: String) async throws
}

struct DeleteScheduleUseCase: DeleteScheduleUseCaseProtocol {
    private let repository: ScheduleRepositoryProtocol

    init(repository: ScheduleRepositoryProtocol) {
        self.repository = repository
    }

    func execute(clubID: String, scheduleID: String) async throws {
        try await repository.deleteSchedule(clubID: clubID, scheduleID: scheduleID)
    }
}
