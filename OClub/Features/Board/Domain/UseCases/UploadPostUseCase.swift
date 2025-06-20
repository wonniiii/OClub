//
//  UploadPostUseCase.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/29/25.
//

import Foundation
import SwiftUI

protocol UploadPostUseCase {
    func execute(clubID: String, title: String, content: String, author: String, image: UIImage?) async throws
}

final class DefaultUploadPostUseCase: UploadPostUseCase {
    private let postRepository: DefaultPostRepository
    private let imageUploadRepository: ImageUploadRepository

    init(postRepository: DefaultPostRepository, imageUploadRepository: ImageUploadRepository) {
        self.postRepository = postRepository
        self.imageUploadRepository = imageUploadRepository
    }

    func execute(clubID: String, title: String, content: String, author: String, image: UIImage?) async throws {
        var imageURL = ""
        
        if let image = image {
            imageURL = try await imageUploadRepository.uploadImage(image: image)
        }
        
        try await postRepository.uploadPost(
            clubID: clubID,
            title: title,
            content: content,
            author: author,
            imageURL: imageURL
        )
    }
}
