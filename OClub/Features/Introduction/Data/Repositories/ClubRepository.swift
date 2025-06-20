//
//  ClubIntroRepository.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import FirebaseFirestore
import FirebaseStorage
import SwiftUI

protocol ClubRepositoryProtocol {
    func fetchClubs(completion: @escaping (Result<[Club], Error>) -> Void)
        func updateClubDescriptionAndImage(
            clubId: String,
            introduction: String,
            image: UIImage?,
            existingImageURL: String,
            completion: @escaping (Result<String, Error>) -> Void
        )
    }

final class ClubRepository: ClubRepositoryProtocol {
    private let firestoreDB = Firestore.firestore()
    
    func fetchClubs(completion: @escaping (Result<[Club], Error>) -> Void) {
        firestoreDB.collection("Clubs").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }

            let clubs: [Club] = documents.compactMap { doc in
                let data = doc.data()
                
                guard
                    let name = data["name"] as? String,
                    let description = data["description"] as? String,
                    let categoryIndex = data["category"] as? Int,
                    let category = ClubCategory(rawValue: categoryIndex),
                    let subtitle = data["subtitle"] as? String,
                    let frequency = data["frequency"] as? String,
                    let logoURL = data["logoURL"] as? String,
                    let imageURL = data["imageURL"] as? String,
                    let leaderUid = data["leaderUid"] as? String,
                    let memberUids = data["memberUids"] as? [String],
                    let timestamp = data["nextMeetingDate"] as? Timestamp,
                    let introduction = data["introduction"] as? String
                else {
                    return nil
                }

                return Club(
                    id: doc.documentID,
                    name: name,
                    description: description,
                    category: category,
                    subtitle: subtitle,
                    frequency: frequency,
                    logoURL: logoURL,
                    imageURL: imageURL,
                    leaderUid: leaderUid,
                    memberUids: memberUids,
                    nextMeetingDate: timestamp.dateValue(),
                    introduction: introduction
                )
            }

            completion(.success(clubs))
        }
    }
    
    func updateClubDescriptionAndImage(
        clubId: String,
        introduction: String,
        image: UIImage?,
        existingImageURL: String,
        completion: @escaping (Result<String, Error>) -> Void 
    ) {
        if let image = image {
            uploadImage(image) { result in
                switch result {
                case .success(let newImageURL):
                    self.updateFirestore(clubId: clubId, introduction: introduction, imageURL: newImageURL) {_ in
                        completion(.success(newImageURL))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            updateFirestore(clubId: clubId, introduction: introduction, imageURL: existingImageURL) {_ in
                completion(.success(existingImageURL))
            }
        }
    }

        private func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
            guard let data = image.jpegData(compressionQuality: 0.8) else {
                completion(.failure(NSError(domain: "ImageConversion", code: -1)))
                return
            }

            let ref = Storage.storage().reference().child("club_images/\(UUID().uuidString).jpg")
            ref.putData(data, metadata: nil) { _, error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    ref.downloadURL { url, error in
                        if let url = url {
                            completion(.success(url.absoluteString))
                        } else {
                            completion(.failure(error ?? NSError(domain: "URLFail", code: -1)))
                        }
                    }
                }
            }
        }

        private func updateFirestore(clubId: String, introduction: String, imageURL: String, completion: @escaping (Result<Void, Error>) -> Void) {
            Firestore.firestore().collection("Clubs").document(clubId).updateData([
                "introduction": introduction,
                "imageURL": imageURL
            ]) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
    
    func fetchClubsByIDs(_ ids: [String]) async throws -> [Club] {
        let database = Firestore.firestore()
        
        var clubs: [Club] = []

        for id in ids {
            let doc = try await database.collection("Clubs").document(id).getDocument()
            if let data = doc.data() {
                clubs.append(Club.from(data: data, id: doc.documentID))
            }
        }

        return clubs
    }
}
