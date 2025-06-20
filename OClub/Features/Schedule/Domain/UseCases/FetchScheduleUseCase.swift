//
//  AddEventUseCase.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import SwiftUI
import FirebaseFirestore

protocol FetchScheduleUseCaseProtocol {
    func execute(clubID: String) async throws -> [Schedule]
    func listen(clubID: String, completion: @escaping (Result<[Schedule], Error>) -> Void) -> ListenerRegistration
    func observe(clubID: String, onUpdate: @escaping (Result<[Schedule], Error>) -> Void) -> ListenerRegistration
}

struct FetchScheduleUseCase: FetchScheduleUseCaseProtocol {
    private let repository: ScheduleRepositoryProtocol
    
    init(repository: ScheduleRepositoryProtocol) {
        self.repository = repository
    }
    func execute(clubID: String) async throws -> [Schedule] {
        try await repository.fetchSchedules(clubID: clubID)
    }
    
    func listen(clubID: String, completion: @escaping (Result<[Schedule], Error>) -> Void) -> ListenerRegistration {
        repository.listenSchedules(clubID: clubID, onUpdate: completion)
    }
    
    func observe(clubID: String, onUpdate: @escaping (Result<[Schedule], Error>) -> Void) -> ListenerRegistration {
        repository.listenSchedules(clubID: clubID, onUpdate: onUpdate)
    }
}
