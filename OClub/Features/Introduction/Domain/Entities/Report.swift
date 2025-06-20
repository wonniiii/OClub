//
//  ClubIntro.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import Foundation

struct Report: Identifiable {
    var id = UUID()
    let date: Date
    let author: String
    let fileUrl: String
}
