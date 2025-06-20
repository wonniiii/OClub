//
//  MainFAQView.swift
//  O'Club
//
//  Created by 최효원 on 4/17/25.
//

import SwiftUI

struct MainFAQDetailView: View {
    @StateObject var viewModel: MainFAQDetailViewModel
    let type: FAQDetailType

    var body: some View {
        ZStack {
            Color.allBackground.ignoresSafeArea()

            VStack(alignment: .leading) {
                NavigationBar(
                    title: viewModel.detail?.title ?? "",
                    rightButtonTitle: nil,
                    rightButtonAction: nil
                )
                Spacer().frame(height: 24)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        if let detail = viewModel.detail {

                            Text(detail.author)
                                .font(.PFootnote)
                                .foregroundStyle(Color.fontLightGray)

                            ForEach(detail.blocks) { block in
                                FAQContentBlockView(block: block)
                            }
                        } else {
                            ProgressView()
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .task {
            await viewModel.load(type: type)
        }
    }
}

struct FAQContentBlockView: View {
    let block: FAQContentBlock

    var body: some View {
        switch block {
        case .text(let text):
            Text(text)
                .font(.PCallout)
                .foregroundColor(.primary)

        case .image(let imageName):
            Image(imageName)
                .resizable()
                .scaledToFit()
                .cornerRadius(8)
        }
    }
}
