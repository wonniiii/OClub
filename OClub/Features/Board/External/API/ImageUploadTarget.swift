//
//  ImageUploadTarget.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/29/25.
//

import Moya
import UIKit

enum ImageUploadTarget {
    case uploadImage(image: UIImage)
}

extension ImageUploadTarget: TargetType {
    var baseURL: URL { URL(string: "http://smartmobiledev.cj.net:6207")! }
    var path: String { "FileUpload/mdoneFileUpload.do" }
    var method: Moya.Method { .post }
    var task: Task {
        switch self {
        case .uploadImage(let image):
            let data = image.jpegData(compressionQuality: 0.8) ?? Data()
            let formData = MultipartFormData(provider: .data(data), name: "file", fileName: "upload.jpg", mimeType: "image/jpeg")
            return .uploadMultipart([formData])
        }
    }
    var headers: [String: String]? {
        ["Content-Type": "multipart/form-data"]
    }
}
