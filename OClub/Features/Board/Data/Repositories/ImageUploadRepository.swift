//
//  Untitled.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/29/25.
//

import SwiftUI

protocol ImageUploadRepositoryProtocol {
    func uploadImage(image: UIImage) async throws -> String
}

final class ImageUploadRepository: ImageUploadRepositoryProtocol {
    private let uploadService = ImageUploadService()

    func uploadImage(image: UIImage) async throws -> String {
        try await uploadService.upload(image: image)
    }
}
