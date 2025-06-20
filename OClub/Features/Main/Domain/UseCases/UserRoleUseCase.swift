//
//  UserRoleUseCase.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/22/25.
//

import Foundation

protocol UserRoleUseCase {
    func fetchCurrentUserRole(completion: @escaping (Result<String, Error>) -> Void)
}
