//
//  NavigationDestination.swift
//  O'Club
//
//  Created by 최효원 on 4/14/25.
//

import SwiftUI

enum NavigationDestination: Hashable {
    case main
    case board(club: Club)
    case boardDetail(clubID: String, post: Post)
    case participants(schedule: Schedule, club: Club)
    case introDetail(club: Club)
    case reportList
    case reportDetail
    case faqDetail(FAQDetailType)
    case writeReport
}
