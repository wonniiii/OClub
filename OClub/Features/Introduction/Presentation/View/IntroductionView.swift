//
//  CalendarView.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import SwiftUI

struct IntroductionView: View {
    @State private var selected = "스포츠"
    @StateObject private var viewModel: ClubViewModel
    @EnvironmentObject private var router: NavigationRouter
    
    init(viewModel: ClubViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            Color.allBackground.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("동호회 소개")
                    .font(.PTitle1).bold()
                    .padding(.top, 12)
                
                SegmentedView(
                    segments: ["스포츠", "여가", "감상 & 체험"],
                    selected: $selected,
                    onSelect: { _ in }
                )
                
                ScrollViewReader { proxy in
                    ScrollView {
                        Color.clear
                            .frame(height: 0)
                            .id("top")
                        
                        LazyVStack(spacing: 16) {
                            ForEach(filteredClubs, id: \.id) { club in
                                ClubListView(
                                    club: club,
                                    onReportTapped: { router.push(.reportList) },
                                    onNavigateTapped: {
                                        router.push(.introDetail(club: club))
                                    }
                                )
                                .padding(8)
                            }
                        }
                    }
                    .onChange(of: selected) { _, _ in
                        withAnimation(nil) {
                            proxy.scrollTo("top", anchor: .top)
                        }
                    }
                }
                .scrollIndicators(.hidden)
            }
            .padding(.horizontal, 20)
        }
        .onAppear {
            viewModel.fetch()
        }
    }
    
    private var filteredClubs: [Club] {
        let selectedCategory = ClubCategory.from(name: selected)
        return viewModel.clubs.filter { $0.category == selectedCategory }
    }
}
