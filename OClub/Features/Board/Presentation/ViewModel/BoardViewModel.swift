//
//  BoardViewModel.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/29/25.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class BoardViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var isLoading: Bool = false
    
    private let fetchPostsUseCase: FetchPostsUseCase
    private let deletePostUseCase: DeletePostUseCaseProtocol
    private let clubID: String
    private var listener: ListenerRegistration?
    
    init(
        fetchPostsUseCase: FetchPostsUseCase,
        deletePostUseCase: DeletePostUseCaseProtocol = DeletePostUseCase(repository: DefaultPostRepository()),
        clubID: String
    ) {
        self.fetchPostsUseCase = fetchPostsUseCase
        self.deletePostUseCase = deletePostUseCase
        self.clubID = clubID
        startListeningPosts()
    }
    
    func startListeningPosts() {
        listener?.remove()
        listener = fetchPostsUseCase.listen(clubID: clubID) { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let posts):
                self.posts = posts
            case .failure(let error):
                print("❌ 실시간 게시글 가져오기 실패:", error)
            }
        }
    }
    
    func deletePost(_ post: Post) async {
            guard let postID = post.id else { return }
            do {
                try await deletePostUseCase.execute(clubID: clubID, postID: postID)
                // Firestore listener가 자동으로 posts에서 지워주지만,
                // 즉시 반영을 원하면:
                posts.removeAll { $0.id == postID }
            } catch {
                print("❌ 게시글 삭제 실패:", error)
            }
        }
    
    deinit {
        listener?.remove()
    }
}
