//
//  BoardDetailView.swift
//  O'Club
//
//  Created by 최효원 on 4/11/25.
//

import SwiftUI

struct BoardDetailView: View {
    let post: Post
    let clubID: String
    @Environment(\.dismiss) private var dismiss
    private let deletePostUC: DeletePostUseCaseProtocol =
    DeletePostUseCase(repository: DefaultPostRepository())
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color.allBackground.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                NavigationBar(
                    title: "",
                    rightButtonTitle: "삭제",
                    rightButtonAction: {
                        showDeleteAlert = true
                    },
                    rightButtonColor: .red
                )
                
                Spacer().frame(height: 20)
                
                Text(post.title)
                    .font(.PHeadline).bold()
                    .padding([.leading, .bottom], 20)
                
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
                    }
                }
                .scaledToFit()
                .frame(height: 200)
                .padding([.horizontal, .bottom], 20)
                
                Text(post.authorUid)
                    .font(.PFootnote)
                    .foregroundStyle(.gray)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                Text(post.content)
                    .font(.PFootnote)
                    .padding(.horizontal, 20)
                
                Spacer()
            }
        }
        .alert("게시글 삭제", isPresented: $showDeleteAlert) {
            Button("삭제", role: .destructive) {
                Task {
                    guard let postID = post.id else { return }
                    do {
                        try await deletePostUC.execute(clubID: clubID, postID: postID)
                    } catch {
                        print("❌ 게시글 삭제 실패:", error)
                    }
                    dismiss()
                }
            }
            Button("취소", role: .cancel) { }
        } message: {
            Text("정말 삭제하시겠습니까?")
        }
    }
}
