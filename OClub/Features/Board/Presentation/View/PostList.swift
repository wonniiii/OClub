//
//  PostList.swift
//  O'Club
//
//  Created by 최효원 on 4/10/25.
//

import SwiftUI

struct PostList: View {
    let post: Post
    let clubID: String
    @EnvironmentObject private var router: NavigationRouter
    
    var body: some View {
        Button(
            action: {
                router.push(.boardDetail(clubID: clubID, post: post))
            }, label: {
                HStack {
                    postImage
                    postDetails
                    Spacer(minLength: 0)
                }
                .frame(maxWidth: .infinity)
            }
        )
        .background(cardBackground)
    }
}

private extension PostList {
    var postImage: some View {
        Group {
            if let imageURLString = post.imageURL,
                let url = URL(string: imageURLString) {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image.resizable()
                    } else {
                        ProgressView()
                    }
                }
            } else {
                Image("noImage")
                    .resizable()
            }
        }
        .frame(width: 80, height: 72)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(12)
    }
    
    var postDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(post.title)
                .font(.PSubhead)
                .bold()
                .foregroundStyle(Color.boardBlue)
                .lineLimit(1)
                .truncationMode(.tail)

            Text(post.content)
                .font(.PCaption)
                .foregroundStyle(Color.lightGray)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .truncationMode(.tail)

            HStack(spacing: 2) {
                Image(systemName: "clock")
                Text(post.createdAt.formattedString)
            }
            .font(.PCaption)
            .foregroundStyle(Color.dateGray)
        }
        .padding(.trailing)
    }
    
    var cardBackground: some View {
        ZStack(alignment: .topTrailing) {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .shadow(color: Color.shadowBlue.opacity(0.15), radius: 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(post.isPinned ? Color.cjYellow : Color.clear, lineWidth: post.isPinned ? 1 : 0)
                )
            if post.isPinned {
                Image("noticeBadge")
                    .resizable()
                    .frame(width: 20, height: 28)
                    .offset(x: -12, y: -5)
            }
        }
    }
}
