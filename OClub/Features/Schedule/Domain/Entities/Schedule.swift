//
//  Event.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import SwiftUI
import FirebaseFirestore

struct Schedule: Identifiable, Codable, Hashable {
    @DocumentID var id: String?
    let name: String
    let date: Date
    let startTime: Date
    let endTime: Date
    let location: String
    var participants: [String]
    var clubID: String = ""
    var clubName: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case date
        case startTime
        case endTime
        case location
        case participants
    }
}
