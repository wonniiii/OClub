//
//  AddScheduleView.swift
//  O'Club
//
//  Created by 최효원 on 4/15/25.
//

import SwiftUI

struct AddScheduleView: View {
    @StateObject private var viewModel: AddScheduleViewModel
    @Environment(\.dismiss) private var dismiss
    let clubs: [Club]

    @State private var showAlert = false
    @State private var alertMessage = ""

    init(viewModel: AddScheduleViewModel, clubs: [Club]) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.clubs = clubs
    }

    var body: some View {
        VStack(spacing: 16) {
            Text("일정 추가")
                .font(.PHeadline)
                .padding(.top, 8)

            Menu {
                ForEach(clubs, id: \.id) { club in
                    Button(club.name) {
                        viewModel.selectedClub = club
                    }
                }
            } label: {
                HStack {
                    Text(viewModel.selectedClub?.name ?? "동호회를 선택하세요")
                    Spacer()
                    Image(systemName: "chevron.down")
                }
                .font(.PSubhead)
                .padding()
                .background(RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.strokeGray))
            }

            ScheduleTextField(placeholder: "모임명", text: $viewModel.title)
            ScheduleTextField(placeholder: "모임 장소", text: $viewModel.place)

            DatePickerField(
                label: viewModel.date.formattedString,
                image: "calendar",
                selection: $viewModel.date,
                components: [.date]
            )

            HStack(spacing: 12) {
                DatePickerField(
                    label: "시작 시간: \(viewModel.startTime.timeFormattedString)",
                    image: "clock",
                    selection: $viewModel.startTime,
                    components: [.hourAndMinute]
                )
                DatePickerField(
                    label: "종료 시간: \(viewModel.endTime.timeFormattedString)",
                    image: "clock",
                    selection: $viewModel.endTime,
                    components: [.hourAndMinute]
                )
            }

            Spacer().frame(height: 12)

            ActionButton(title: "추가하기") {
                if viewModel.selectedClub == nil ||
                   viewModel.title.trimmingCharacters(in: .whitespaces).isEmpty ||
                   viewModel.place.trimmingCharacters(in: .whitespaces).isEmpty {
                    alertMessage = "동호회, 모임명, 장소를 모두 입력해주세요."
                    showAlert = true
                } else {
                    viewModel.add { result in
                        switch result {
                        case .success:
                            dismiss()
                        case .failure(let error):
                            print("추가 실패:", error)
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .alert("입력 오류", isPresented: $showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}

struct ScheduleTextField: View {
    let placeholder: String
    @Binding var text: String
    var body: some View {
        TextField(placeholder, text: $text)
            .font(.PSubhead)
            .padding()
            .background(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.strokeGray))
    }
}

struct DatePickerField: View {
    let label: String
    let image: String
    @Binding var selection: Date
    let components: DatePickerComponents

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Image(systemName: image)
                .overlay {
                    DatePicker("", selection: $selection, displayedComponents: components)
                        .labelsHidden()
                        .datePickerStyle(.compact)
                        .opacity(0.011)
                }
        }
        .font(.PSubhead)
        .padding()
        .background(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.strokeGray))
    }
}
