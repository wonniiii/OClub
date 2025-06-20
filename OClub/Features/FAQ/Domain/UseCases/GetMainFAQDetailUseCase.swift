//
//  FetchFAQListUseCase.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import Foundation

struct GetMainFAQDetailUseCase {
    let repository: FAQRepository

    func execute(type: FAQDetailType) async throws -> MainFAQDetailItem {
        try await repository.getDetail(by: type)
    }
}
