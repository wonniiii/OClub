//
//  FetchPostUseCase.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/29/25.
//

import SwiftUI
import FirebaseFirestore

protocol FetchPostsUseCaseProtocol {
    func execute(clubID: String) async throws -> [Post]
    func listen(clubID: String, completion: @escaping (Result<[Post], Error>) -> Void) -> ListenerRegistration
}

struct FetchPostsUseCase: FetchPostsUseCaseProtocol {
    private let repository: PostRepositoryProtocol

    init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }

    func execute(clubID: String) async throws -> [Post] {
        try await repository.fetchPosts(clubID: clubID)
    }

    func listen(clubID: String, completion: @escaping (Result<[Post], Error>) -> Void) -> ListenerRegistration {
        repository.listenPosts(clubID: clubID, completion: completion)
    }
}
