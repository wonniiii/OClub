//
//  FetchClubIntroListUseCase.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import SwiftUI

protocol FetchClubsUseCaseProtocol {
    func execute(completion: @escaping (Result<[Club], Error>) -> Void)
}

final class FetchClubsUseCase: FetchClubsUseCaseProtocol {
    private let repository: ClubRepositoryProtocol
    
    init(repository: ClubRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (Result<[Club], Error>) -> Void) {
        repository.fetchClubs(completion: completion)
    }
}
