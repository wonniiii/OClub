//
//  Post.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import SwiftUI

enum InfoCategory: Int, CaseIterable {
    case category
    case frequency
    case personNumber 
    
    var systemImageName: String {
        switch self {
        case .category:
            return "line.3.horizontal.decrease.circle"
        case .frequency:
            return "calendar"
        case .personNumber:
            return "person"
        }
    }
}

struct InfoItem: Identifiable {
    let id = UUID()
    let title: String
    let type: InfoCategory
    
    var systemImageName: String {
        return type.systemImageName
    }
}
