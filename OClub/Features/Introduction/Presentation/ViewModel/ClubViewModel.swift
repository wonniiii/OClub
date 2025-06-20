//
//  ClubViewModel.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/24/25.
//

import Foundation

final class ClubViewModel: ObservableObject {
    @Published var clubs: [Club] = []
    @Published var error: Error?
    
    private let fetchUseCase: FetchClubsUseCaseProtocol

    init(fetchUseCase: FetchClubsUseCaseProtocol) {
        self.fetchUseCase = fetchUseCase
    }

    func fetch() {
        fetchUseCase.execute { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let clubs):
                    self?.clubs = clubs
                case .failure(let error):
                    self?.error = error
                    print("[ERROR] Firestore 가져오기 실패: \(error.localizedDescription)")
                }
            }
        }
    }
}
