//
//  BottomViewModel.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/22/25.
//

import Foundation

final class BottomActionViewModel: ObservableObject {
    @Published var role: String = ""
    @Published var isLoading = true
    
    private let roleUseCase: UserRoleUseCase
    
    init(roleUseCase: UserRoleUseCase) {
        self.roleUseCase = roleUseCase
        fetchRole()
    }
    
    func fetchRole() {
        isLoading = true
        roleUseCase.fetchCurrentUserRole { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let role):
                    self?.role = role
                case .failure(let error):
                    print("Error fetching role: \(error)")
                }
            }
        }
    }
}
