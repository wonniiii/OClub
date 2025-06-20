//
//  BoardView.swift
//  O'Club
//
//  Created by 최효원 on 4/10/25.
//

import SwiftUI
import FirebaseFirestore
import Moya
import SwiftyJSON

struct BoardView: View {
    let club: Club
    @State private var isShowingSheet = false
    @StateObject private var viewModel: BoardViewModel
    
    init(club: Club) {
        self.club = club
        _viewModel = StateObject(
            wrappedValue: BoardViewModel(
                fetchPostsUseCase: FetchPostsUseCase(repository: DefaultPostRepository()),
                clubID: club.id
            )
        )
    }

    var body: some View {
        ZStack {
            Color.allBackground
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                NavigationBar(
                    title: club.name,
                    rightButtonTitle: "작성하기",
                    rightButtonAction: {
                        isShowingSheet = true
                    }
                )

                ScrollView {
                    if viewModel.posts.isEmpty {
                        VStack {
                            Spacer()
                            Text("게시글이 없습니다.")
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    } else {
                        VStack(spacing: 16) {
                            Text("총 \(viewModel.posts.count)개")
                                .font(.PCaption)
                                .foregroundStyle(Color.fontLightGray).bold()
                            ForEach(viewModel.posts) { post in
                                PostList(post: post, clubID: club.id)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                    }
                }
                .padding(.vertical, 20)

                Spacer()
            }
        }
        .sheet(isPresented: $isShowingSheet) {
            WritePostSheet(clubID: club.id)
                .presentationDetents([.medium, .large])
        }
    }
}
