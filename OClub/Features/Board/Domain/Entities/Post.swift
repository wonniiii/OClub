//
//  Post.swift
//  O'Club
//
//  Created by 최효원 on 4/11/25.
//

import SwiftUI
import FirebaseFirestore

struct Post: Identifiable, Codable, Hashable, Equatable {
    @DocumentID var id: String?
    let title: String
    let content: String
    let imageURL: String?
    let authorUid: String
    let isPinned: Bool
    let createdAt: Date
}
