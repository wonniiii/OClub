//
//  FAQRepository.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import Foundation

protocol FAQRepository {
    func getDetail(by type: FAQDetailType) async throws -> MainFAQDetailItem
}

final class FAQRepositoryImpl: FAQRepository {
    let remote: FAQRemoteDataSource

    init(remote: FAQRemoteDataSource) {
        self.remote = remote
    }

    func getDetail(by type: FAQDetailType) async throws -> MainFAQDetailItem {
        try await remote.fetchMainFAQDetail(type: type)
    }
}
