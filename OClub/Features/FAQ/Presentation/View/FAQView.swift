//
//  FAQView.swift
//  O'Club
//
//  Created by 최효원 on 4/8/25.
//

import SwiftUI

struct FAQView: View {
    @StateObject private var viewModel = FAQViewModel()
    @EnvironmentObject private var router: NavigationRouter

    var body: some View {
        ZStack {
            Color.allBackground.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 16) {
                Text("FAQ")
                    .font(.PTitle1.bold())
                    .padding(.top, 12)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(viewModel.mainItems) { item in
                            MainFAQCardView(item: item) {
                                if let type = viewModel.routeFor(item: item) {
                                    router.push(.faqDetail(type))
                                }
                            }
                        }
                    }
                    .padding()
                }

                Text("Questions")
                    .font(.PCalloutBold)
                    .padding(.leading)
                ScrollView {
                    VStack(spacing: 12) {
                        ForEach(viewModel.faqItems) { item in
                            ExpandableFAQView(item: item)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    FAQView()
}
