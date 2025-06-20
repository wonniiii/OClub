//
//  FirebaseUserRepository.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/22/25.
//

import Foundation
import FirebaseFirestore

protocol UserRepositoryProtocol {
    func fetchUser(userID: String) async throws -> User
}

final class UserRepository: UserRepositoryProtocol {
    func fetchUser(userID: String) async throws -> User {
        let snapshot = try await Firestore.firestore().collection("Users").document(userID).getDocument()
        
        guard let data = snapshot.data() else {
            throw URLError(.badServerResponse)
        }
        
        return User(
            name: data["name"] as? String ?? "",
            role: UserRole(rawValue: data["role"] as? Int ?? 0) ?? .member,
            clubs: data["clubs"] as? [Int] ?? [],
            leadingClubs: data["leadingClubs"] as? [Int] ?? []
        )
    }
}
