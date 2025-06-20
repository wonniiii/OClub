//
//  IntroductionDetailView.swift
//  O'Club
//
//  Created by 최효원 on 4/16/25.
//

import SwiftUI

struct IntroductionDetailView: View {
    @StateObject private var viewModel: ClubDetailViewModel
    private let useCase: UpdateClubIntroUseCaseProtocol

    init(viewModel: ClubDetailViewModel, useCase: UpdateClubIntroUseCaseProtocol) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.useCase = useCase
    }

    var body: some View {
        ZStack {
            Color.allBackground.ignoresSafeArea()
            VStack {
                NavigationBar(
                    title: "동호회 소개",
                    rightButtonTitle: "수정",
                    rightButtonAction: {
                        viewModel.toggleSheet()
                    }
                )

                ScrollView {
                    AsyncImage(url: URL(string: viewModel.club.imageURL)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView().frame(height: 240)
                        case .success(let image):
                            image.resizable().scaledToFit().frame(height: 240)
                        case .failure:
                            EmptyView()
                        @unknown default:
                            EmptyView()
                        }
                    }

                    Text(viewModel.club.introduction)
                        .padding(.top, 8)
                    Spacer()
                }
                .scrollIndicators(.hidden)
                .padding([.top, .horizontal], 20)
            }
        }
        .sheet(isPresented: $viewModel.isShowingSheet) {
            WriteIntroductionSheet(
                club: viewModel.club,
                useCase: useCase
            ) { updatedDescription, updatedImageURL in
                viewModel.updateClub(
                    introduction: updatedDescription,
                    imageURL: updatedImageURL
                )
            }
        }
        .presentationDetents([.medium, .large])
    }
}
