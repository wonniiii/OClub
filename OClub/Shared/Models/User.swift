//
//  User.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import SwiftUI

struct User: Hashable {
    let name: String
    let role: UserRole
    let clubs: [Int]
    let leadingClubs: [Int]
}

enum UserRole: Int {
    case member = 0
    case admin = 1
}
