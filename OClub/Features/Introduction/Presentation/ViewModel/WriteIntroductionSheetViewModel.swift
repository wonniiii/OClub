//
//  WriteIntroductionSheetViewModel.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/25/25.
//

import Foundation
import SwiftUI
import PhotosUI

final class WriteIntroductionSheetViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem? {
        didSet { loadImage() }
    }
    @Published var selectedImage: UIImage?
    @Published var postContent: String
    
    let originalImageURL: String
    private let clubId: String
    private let useCase: UpdateClubIntroUseCaseProtocol
    
    init(club: Club, useCase: UpdateClubIntroUseCaseProtocol) {
        self.clubId = club.id
        self.postContent = club.introduction
        self.originalImageURL = club.imageURL
        self.useCase = useCase
    }
    
    private func loadImage() {
        guard let item = selectedItem else { return }
        Task {
            do {
                let data = try await item.loadTransferable(type: Data.self)
                if let data, let image = UIImage(data: data) {
                    await MainActor.run { self.selectedImage = image }
                }
            } catch {
                print("이미지 로드 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func submit(completion: @escaping (Result<(String, String), Error>) -> Void) {
        useCase.execute(
            clubId: clubId,
            introduction: postContent,
            image: selectedImage,
            existingImageURL: originalImageURL,
            completion: { result in
                switch result {
                case .success(let updatedURL):
                    completion(.success((self.postContent, updatedURL)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
}
