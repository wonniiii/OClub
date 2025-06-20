//
//  PostRepository.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/29/25.
//

import SwiftUI
import FirebaseFirestore

protocol PostRepositoryProtocol {
    func fetchPosts(clubID: String) async throws -> [Post]
    func uploadPost(clubID: String, title: String, content: String, author: String, imageURL: String) async throws
    func listenPosts(clubID: String, completion: @escaping (Result<[Post], Error>) -> Void) -> ListenerRegistration
    func deletePost(clubID: String, postID: String) async throws
}

final class DefaultPostRepository: PostRepositoryProtocol {
    private let database = Firestore.firestore()
    
    func fetchPosts(clubID: String) async throws -> [Post] {
        let snapshot = try await database.collection("Clubs").document(clubID).collection("posts")
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap { try? $0.data(as: Post.self) }
    }
    
    func uploadPost(clubID: String, title: String, content: String, author: String, imageURL: String) async throws {
        let newPost = Post(
            id: nil,
            title: title,
            content: content,
            imageURL: imageURL,
            authorUid: author,
            isPinned: false,
            createdAt: Date()
        )
        
        try database.collection("Clubs").document(clubID).collection("posts")
            .addDocument(from: newPost)
    }
    
    func listenPosts(clubID: String, completion: @escaping (Result<[Post], Error>) -> Void) -> ListenerRegistration {
        return database.collection("Clubs").document(clubID).collection("posts")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                } else if let snapshot = snapshot {
                    var posts = snapshot.documents.compactMap { try? $0.data(as: Post.self) }
                    
                    posts.sort { lhs, rhs in
                        if lhs.isPinned != rhs.isPinned {
                            return lhs.isPinned && !rhs.isPinned
                        } else {
                            return lhs.createdAt > rhs.createdAt
                        }
                    }
                    
                    completion(.success(posts))
                }
            }
    }
    
    func deletePost(clubID: String, postID: String) async throws {
        try await database
            .collection("Clubs")
            .document(clubID)
            .collection("posts")
            .document(postID)
            .delete()
    }
    
}
