//
//  UpdateParticipantsUseCase.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 5/12/25.
//

protocol UpdateParticipantUseCaseProtocol {
    func add(userID: String, to scheduleID: String, in clubID: String) async throws
    func remove(userID: String, from scheduleID: String, in clubID: String) async throws
}

struct UpdateParticipantUseCase: UpdateParticipantUseCaseProtocol {
    private let repository: ScheduleRepositoryProtocol
    init(repository: ScheduleRepositoryProtocol) {
        self.repository = repository
    }
    func add(userID: String, to scheduleID: String, in clubID: String) async throws {
        try await repository.addParticipant(userID: userID, to: scheduleID, in: clubID)
    }
    func remove(userID: String, from scheduleID: String, in clubID: String) async throws {
        try await repository.removeParticipant(userID: userID, from: scheduleID, in: clubID)
    }
}
