//
//  Club.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import SwiftUI
import FirebaseCore

// 클럽 정보
struct Club: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let category: ClubCategory
    let subtitle: String
    let frequency: String
    let logoURL: String
    let imageURL: String
    let leaderUid: String
    let memberUids: [String]
    let nextMeetingDate: Date
    let introduction: String
}

enum ClubCategory: Int {
    case sports = 0
    case leisure = 1
    case experience = 2

    var name: String {
        switch self {
        case .sports: return "스포츠"
        case .leisure: return "여가"
        case .experience: return "감상 & 체험"
        }
    }

    static func from(name: String) -> ClubCategory? {
        switch name {
        case "스포츠": return .sports
        case "여가": return .leisure
        case "감상 & 체험": return .experience
        default: return nil
        }
    }
}

extension Club {
    var infoItems: [InfoItem] {
        [
            InfoItem(title: category.name, type: .category),
            InfoItem(title: frequency, type: .frequency),
            InfoItem(title: "\(memberUids.count)명", type: .personNumber)
        ]
    }
    
    static func from(data: [String: Any], id: String) -> Club {
           return Club(
               id: id,
               name: data["name"] as? String ?? "",
               description: data["description"] as? String ?? "",
               category: ClubCategory(rawValue: data["category"] as? Int ?? 0) ?? .sports,
               subtitle: data["subtitle"] as? String ?? "",
               frequency: data["frequency"] as? String ?? "",
               logoURL: data["logoURL"] as? String ?? "",
               imageURL: data["imageURL"] as? String ?? "",
               leaderUid: data["leaderUid"] as? String ?? "",
               memberUids: data["memberUids"] as? [String] ?? [],
               nextMeetingDate: (data["nextMeetingDate"] as? Timestamp)?.dateValue() ?? Date(),
               introduction: data["introduction"] as? String ?? ""
           )
       }
}
