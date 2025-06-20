//
//  ImageUploadService.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/29/25.
//

import Moya
import SwiftyJSON

struct ImageUploadService {
    private let provider = MoyaProvider<ImageUploadTarget>()

    func upload(image: UIImage) async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.uploadImage(image: image)) { result in
                switch result {
                case .success(let response):
                    let data = response.data
                    let json = JSON(data)
                    print("서버 응답:", json)

                    if let url = json["fileUrl"].string {
                        continuation.resume(returning: url)
                    } else {
                        continuation.resume(throwing: URLError(.badServerResponse))
                    }

                case .failure(let error):
                    print("❌ 업로드 실패:", error.localizedDescription)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
