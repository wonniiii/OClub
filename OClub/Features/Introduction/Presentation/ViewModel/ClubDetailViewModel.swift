//
//  ClubDetailViewModel.swift
//  OClub
//
//  Created by AM 2팀 최효원 on 4/25/25.
//

import SwiftUI

final class ClubDetailViewModel: ObservableObject {
    @Published var club: Club
    @Published var isShowingSheet: Bool = false

    init(club: Club) {
        self.club = club
    }

    func toggleSheet() {
        isShowingSheet.toggle()
    }

    func updateClub(introduction: String, imageURL: String) {
        club = Club(
            id: club.id,
            name: club.name,
            description: club.description,
            category: club.category,
            subtitle: club.subtitle,
            frequency: club.frequency,
            logoURL: club.logoURL,
            imageURL: imageURL,
            leaderUid: club.leaderUid,
            memberUids: club.memberUids,
            nextMeetingDate: club.nextMeetingDate,
            introduction: introduction
        )
    }
}
