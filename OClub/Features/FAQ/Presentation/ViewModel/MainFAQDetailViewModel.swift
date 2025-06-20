//
//  MainFAQDetailViewModel.swift
//  O'Club
//
//  Created by 최효원 on 4/17/25.
//

import SwiftUI

final class MainFAQDetailViewModel: ObservableObject {
    @Published var detail: MainFAQDetailItem?

    private let getDetailUseCase: GetMainFAQDetailUseCase

    init(useCase: GetMainFAQDetailUseCase) {
        self.getDetailUseCase = useCase
    }

    func load(type: FAQDetailType) async {
        do {
            let result = try await getDetailUseCase.execute(type: type)
            await MainActor.run {
                self.detail = result
            }
        } catch {
            print("Error loading FAQ detail:", error)
        }
    }
}
