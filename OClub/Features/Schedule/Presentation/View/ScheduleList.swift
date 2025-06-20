//
//  ScheduleList.swift
//  O'Club
//
//  Created by 최효원 on 4/15/25.
//

import SwiftUI

struct ScheduleList: View {
    let schedule: Schedule
    let club: Club
    let onDelete: () -> Void
    @EnvironmentObject private var viewModel: ScheduleViewModel
    @EnvironmentObject private var router: NavigationRouter
    @State private var isAttend = false
    @State private var showDeleteAlert = false
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)"
        return formatter
    }()
    static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a h:mm"
        formatter.amSymbol = "오전"
        formatter.pmSymbol = "오후"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(schedule.clubName)
                    .font(.PSubhead).bold()
                Spacer()
                Button {
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "xmark")
                        .font(.footnote)
                        .foregroundColor(.red)
                }
                .alert("정말 삭제하시겠습니까?", isPresented: $showDeleteAlert) {
                    Button("삭제", role: .destructive) {
                        onDelete()
                    }
                    Button("취소", role: .cancel) { }
                }
            }
            
            Text(schedule.name)
                .font(.PCaption)
                .padding(.bottom, 2)
            
            Group {
                Label(Self.dateFormatter.string(from: schedule.date), systemImage: "calendar")
                Label(
                    "\(Self.timeFormatter.string(from: schedule.startTime)) ~ \(Self.timeFormatter.string(from: schedule.endTime))",
                    systemImage: "clock"
                )
                Label(schedule.location, systemImage: "mappin")
            }
            .font(.PFootnote)
            .foregroundStyle(Color.fontLightGray)
            .padding(.bottom, 2)
            
            HStack {
                Toggle("참석 가능", isOn: $isAttend)
                    .font(.PSubheadBold)
                    .toggleStyle(CheckboxToggleStyle())
                    .onChange(of: isAttend) { _, newValue in
                        Task {
                            viewModel.toggleAttendance(schedule: schedule, isOn: newValue)
                        }
                    }
                
                Spacer()
                
                Button {
                    router.push(.participants(schedule: schedule, club: club))
                } label: {
                    Label("\(schedule.participants.count)명 >", systemImage: "person.fill")
                        .font(.PSubheadBold)
                }
            }
            .foregroundStyle(Color.accentColor)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(.white))
        .onAppear {
            isAttend = schedule.participants.contains(viewModel.currentUserID)
        }
        .onChange(of: schedule.participants) { _, _ in
            isAttend = schedule.participants.contains(viewModel.currentUserID)
        }
    }
}

struct ScheduleEmptyView: View {
    var body: some View {
        Text("예정된 모임이 없습니다")
            .font(.PFootnote)
            .foregroundStyle(Color.fontLightGray)
    }
}
