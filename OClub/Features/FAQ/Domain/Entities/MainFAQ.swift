//
//  FAQ.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import SwiftUI

struct MainFAQ: Identifiable {
    let id = UUID()
    let imageName: String
    let backgroundColor: Color
    let foregroundColor: Color
    let title: String
}

enum FAQContentBlock: Identifiable {
    case text(String)
    case image(String)
    
    var id: UUID { UUID() }
}

struct MainFAQDetailItem {
    let title: String
    let author: String
    let blocks: [FAQContentBlock]
}
