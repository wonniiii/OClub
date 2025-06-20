//
//  AddScheduleUseCase.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 5/12/25.
//

import FirebaseFirestore

protocol AddScheduleUseCaseProtocol {
    func execute(_ schedule: Schedule) async throws
}

struct AddScheduleUseCase: AddScheduleUseCaseProtocol {
    private let repository: ScheduleRepositoryProtocol
    init(repository: ScheduleRepositoryProtocol) {
        self.repository = repository
    }
    func execute(_ schedule: Schedule) async throws {
        try await repository.addSchedule(schedule)
    }
}
