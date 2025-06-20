//
//  ParticipantsView.swift
//  O'Club
//
//  Created by 최효원 on 4/15/25.
//

import SwiftUI

struct ParticipantsView: View {
    let schedule: Schedule
    let club: Club

    @State private var selected = "참석"

    private let columns = [ GridItem(.flexible()), GridItem(.flexible()) ]

    private var attending: [String] { schedule.participants }
    private var notAttending: [String] {
        club.memberUids.filter { !schedule.participants.contains($0) }
    }

    var body: some View {
        ZStack {
            Color.allBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                NavigationBar(
                    title: "모임 참여 인원",
                    rightButtonTitle: nil,
                    rightButtonAction: nil
                )

                SegmentedView(
                    segments: ["참석", "미참석"],
                    selected: $selected,
                    onSelect: { _ in }
                )
                .padding(.vertical, 8)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(currentList, id: \.self) { uid in
                            ParticipantCell(name: uid)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                Spacer()
            }
        }
    }

    private var currentList: [String] {
        selected == "참석" ? attending : notAttending
    }
}

struct ParticipantCell: View {
    let name: String
    var body: some View {
        HStack {
            Text(name).font(.PFootnote)
            Spacer()
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(.white))
    }
}
