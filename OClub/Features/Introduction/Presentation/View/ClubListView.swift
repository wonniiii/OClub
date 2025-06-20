//
//  ClubListView.swift
//  O'Club
//
//  Created by 최효원 on 4/16/25.
//

import SwiftUI

struct ClubListView: View {
    let club: Club
    let onReportTapped: () -> Void
    let onNavigateTapped: () -> Void
    @EnvironmentObject private var router: NavigationRouter

    var body: some View {
        VStack(spacing: 16) {
            headerSection
            Divider().padding(.vertical, 10)
            footerSection
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 22)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.white)
                .shadow(radius: 2)
        )
    }

    private var headerSection: some View {
        HStack(alignment: .top, spacing: 12) {
            AsyncImage(url: URL(string: club.logoURL)) { phase in
                if let image = phase.image {
                    image.resizable()
                } else {
                    ProgressView()
                }
            }
                .frame(width: 70, height: 70)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(club.name)
                        .font(.PSubheadBold)

                    Spacer()
                }

                Text(club.subtitle)
                    .font(.PCaption2)
                    .lineSpacing(1.5)
                    .foregroundStyle(Color.dateGray)
                    .padding(.trailing, 28)
            }
        }
    }

    private var footerSection: some View {
        HStack {
            Text("인원: \(club.memberUids.count)명")
            Spacer()
            Button(action: onNavigateTapped) {
                Text("소개글 보기")
            }
        }
        .font(.PFootnoteBold)
        .padding(.horizontal, 20)
    }
}
