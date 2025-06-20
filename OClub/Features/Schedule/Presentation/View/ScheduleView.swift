//
//  CalendarView.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import SwiftUI

struct ScheduleView: View {
    let clubs: [Club]
    @StateObject private var viewModel: ScheduleViewModel
    @AppStorage("cjUserIDOnly") private var storedUserID: String = ""
    
    private var clubsByID: [String: Club] {
        Dictionary(uniqueKeysWithValues: clubs.map { ($0.id, $0) })
    }
    
    init(clubs: [Club], storedUserID: String) {
        self.clubs = clubs
        self.storedUserID = storedUserID
        let repo = ScheduleRepository()
        let fetchUC = FetchScheduleUseCase(repository: repo)
        let updateUC = UpdateParticipantUseCase(repository: repo)
        let deleteUC = DeleteScheduleUseCase(repository: repo)
        _viewModel = StateObject(
            wrappedValue: ScheduleViewModel(
                currentUserID: "sim7480",
                clubs: clubs,
                fetchUseCase: fetchUC,
                deleteUseCase: deleteUC,
                updateParticipantUseCase: updateUC
            )
        )
    }
    
    var body: some View {
        ZStack {
            Color.allBackground.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading) {
                    header
                    calendar
                    content
                }
                .padding(.horizontal, 20)
            }
        }
        .environmentObject(viewModel)
        .sheet(isPresented: $viewModel.isShowingSheet) {
            let repo = ScheduleRepository()
            let addUC = AddScheduleUseCase(repository: repo)
            AddScheduleView(viewModel: AddScheduleViewModel(addUseCase: addUC), clubs: clubs)
                .presentationDragIndicator(.visible)
                .presentationDetents([.fraction(0.65)])
        }
    }
    
    var header: some View {
        HStack {
            Text("일정")
                .font(.PTitle1).bold()
                .padding(.top, 12)
            Spacer()
            Button {
                viewModel.isShowingSheet = true
            } label: {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
            .foregroundStyle(.black)
        }
    }
    
    var calendar: some View {
        CustomCalendarView(
            calendarMonth: $viewModel.calendarMonth,
            selectedDate: $viewModel.selectedDate,
            datesToHighlight: viewModel.schedules.map { $0.date },
            onMonthChange: { delta in
                print("달 변경됨: \(delta)")
            }
            
        )
        .padding()
        .background(RoundedRectangle(cornerRadius: 8).fill(.white))
    }
    
    var content: some View {
        VStack(alignment: .leading) {
            Text("다가오는 모임")
                .font(.PCallout).bold()
                .padding(.vertical)
            
            if viewModel.filteredSchedules.isEmpty {
                ScheduleEmptyView()
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 32)
            } else {
                ForEach(viewModel.filteredSchedules, id: \.id) { schedule in
                    if let club = clubsByID[schedule.clubID] {
                        ScheduleList(
                            schedule: schedule,
                            club: club,
                            onDelete: {
                                Task {
                                    await viewModel.deleteSchedule(schedule)
                                }
                            }
                        )
                        .padding(.bottom, 12)
                    } else {
                        Text("Unknown Club")
                    }
                }
            }
        }
    }
}
