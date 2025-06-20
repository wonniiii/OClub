//
//  MainCardContentView.swift
//  O'Club
//
//  Created by 최효원 on 4/10/25.
//

import SwiftUI

struct MainCardContentView: View {
    let club: Club
    let userInfo: UserInfo
    let latestPostDate: Date?
    let nextMeetingDate: Date?
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 12) {
                ProfileHeaderView(
                    imageURL: club.logoURL,
                    clubName: club.name,
                    clubSubName: club.description
                )
                
                HStack(spacing: 12) {
                    ForEach(club.infoItems) { item in
                        CategoryCapsuleView(info: item)
                    }
                }
                .font(.PCaption)
                .foregroundStyle(.white)
                
                Text(club.subtitle)
                    .font(.PFootnote)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.white)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            BottomActionView(
                isLeader: club.leaderUid == userInfo.userID,
                meetingDate: nextMeetingDate,
                latestPostDate: latestPostDate
            )
            .padding(.bottom, 4)
        }
        .padding(.horizontal, 20)
        .padding()
    }
}

struct CategoryCapsuleView: View {
    let info: InfoItem
    
    var body: some View {
        Label(info.title, systemImage: info.systemImageName)
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(Capsule().strokeBorder(Color.white.opacity(0.6), lineWidth: 0.8))
            .background(Color.white.opacity(0.3))
            .clipShape(Capsule())
    }
}

struct ProfileHeaderView: View {
    let imageURL: String
    let clubName: String
    let clubSubName: String
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: imageURL)) { phase in
                if let image = phase.image {
                    image.resizable()
                } else {
                    ProgressView()
                }
            }
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(clubName)
                    .font(.PHeadline)
                Text(clubSubName)
                    .font(.PCaption)
            }
            Spacer()
        }
        .foregroundStyle(.white)
    }
}

struct BottomActionView: View {
    let isLeader: Bool
    let meetingDate: Date?
    let latestPostDate: Date?
    
    var body: some View {
        HStack {
            if let date = latestPostDate {
                HStack {
                    Image(systemName: "timer")
                    Text("Posted \(relativeDate(from: date))")
                        .font(.PCaption2)
                }
            } else {
                Text("No posts yet")
                    .font(.PCaption2)
            }
            Spacer()
            
            if let meetingDate {
                (
                    Text("다음 모임 ")
                        .font(.PFootnote)
                    +
                    Text(dDayString(from: meetingDate))
                        .bold()
                        .font(.PHeadline)
                )
                .foregroundStyle(.primary)
            } else {
                Text("다음 모임 없음")
                    .font(.PFootnote)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }
    
    private func relativeDate(from date: Date) -> String {
        let koreaTimeZone = TimeZone(identifier: "Asia/Seoul")!
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = koreaTimeZone

        let today = calendar.startOfDay(for: Date())
        let postDate = calendar.startOfDay(for: date)

        let components = calendar.dateComponents([.day], from: postDate, to: today)
        let daysAgo = components.day ?? 0

        return daysAgo == 0 ? "Today" : "\(daysAgo) days ago"
    }
    
    private func dDayString(from date: Date) -> String {
        let calendar = Calendar.current
        let startOfToday = calendar.startOfDay(for: Date())
        let startOfMeeting = calendar.startOfDay(for: date)
        
        guard let days = calendar.dateComponents([.day], from: startOfToday, to: startOfMeeting).day else {
            return ""
        }
        
        if days > 0 {
            return "D-\(days)"
        } else if days == 0 {
            return "D-day"
        } else {
            return "없음"
        }
    }
}
