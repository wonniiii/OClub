//
//  WriteBottomSheetViewModel.swift
//  O'Club
//
//  Created by 최효원 on 4/11/25.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore

@MainActor
final class WriteBottomSheetViewModel: ObservableObject {
    @Published var postTitle: String = ""
    @Published var postContent: String = ""
    @Published var selectedImage: UIImage?
    @Published var triggerGallery = false
    @Published var isShowingPhotoPicker: Bool = false
    @AppStorage("cjUserIDOnly") private var storedUserID: String = ""
    @Published var selectedItem: PhotosPickerItem? {
        didSet {
            if selectedItem != oldValue {
                Task { await loadSelectedImage() }
            }
        }
    }
    
    private let postRepository: PostRepositoryProtocol
    private let uploadService: ImageUploadService
    private let clubID: String
    
    init(
        clubID: String,
        postRepository: PostRepositoryProtocol = DefaultPostRepository(),
        uploadService: ImageUploadService = ImageUploadService()
    ) {
        self.clubID = clubID
        self.postRepository = postRepository
        self.uploadService = uploadService
    }
    
    func presentGallery() {
            triggerGallery = false
        }

        func loadImageFromPicker() async {
            guard let item = selectedItem else { return }
            do {
                if let data = try await item.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    await MainActor.run {
                        self.selectedImage = uiImage
                    }
                }
            } catch {
                print("이미지 로드 실패:", error)
            }
        }

    func loadSelectedImage() async {
        guard let item = selectedItem else {
            return
        }
        
        if let data = try? await item.loadTransferable(type: Data.self),
           let image = UIImage(data: data) {
            self.selectedImage = image
        }
    }
    
    func uploadPost(completion: @escaping (Bool) -> Void) {
        guard !postTitle.isEmpty, !postContent.isEmpty else {
            print("❌ 제목과 내용을 모두 입력하세요.")
            completion(false)
            return
        }
        
        Task {
            do {
                var imageURL = ""
                
                if let selectedImage = selectedImage {
                    imageURL = try await uploadService.upload(image: selectedImage)
                }
                                
                try await postRepository.uploadPost(
                    clubID: clubID,
                    title: postTitle,
                    content: postContent,
                    author: "sim7480",
                    imageURL: imageURL
                )
                
                completion(true)
            } catch {
                print("❌ 업로드 실패: \(error)")
                completion(false)
            }
        }
    }
    
}
