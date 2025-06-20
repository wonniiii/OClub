//
//  DeletePostUseCase.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 5/15/25.
//

protocol DeletePostUseCaseProtocol {
    func execute(clubID: String, postID: String) async throws
}

struct DeletePostUseCase: DeletePostUseCaseProtocol {
    private let repository: PostRepositoryProtocol
    
    init(repository: PostRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(clubID: String, postID: String) async throws {
        try await repository.deletePost(clubID: clubID, postID: postID)
    }
}
