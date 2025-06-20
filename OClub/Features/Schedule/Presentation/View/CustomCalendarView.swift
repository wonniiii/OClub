//
//  CalendarGridView.swift
//  O'Club
//
//  Created by 최효원 on 4/15/25.
//

import SwiftUI

struct CustomCalendarView: View {
    @Binding var calendarMonth: Date
    @Binding var selectedDate: Date
    let datesToHighlight: [Date]
    var onMonthChange: (Int) -> Void
    private let calendar = Calendar.current
    private var days: [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: calendarMonth),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday
        else { return [] }
        
        let daysInMonth = calendar.range(of: .day, in: .month, for: calendarMonth)!.count
        let offsetDays = firstWeekday - calendar.firstWeekday
        
        var dates: [Date] = []
        for index in 0..<(daysInMonth + offsetDays) {
            if index < offsetDays {
                dates.append(Date.distantPast)
            } else {
                let date = calendar.date(byAdding: .day, value: index - offsetDays, to: monthInterval.start)!
                dates.append(date)
            }
        }
        return dates
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(calendarMonth.yearMonthFormattedString)
                    .font(.PHeadline)
                Spacer()
                Button(
                    action:
                        {
                            calendarMonth = calendar.date(byAdding: .month, value: -1, to: calendarMonth)!
                        }, label: {
                            Image(systemName: "chevron.left")
                        }
                )
                .padding(.horizontal)
                
                Button(
                    action:
                        {
                            calendarMonth = calendar.date(byAdding: .month, value: 1, to: calendarMonth)!
                        }, label: {
                            Image(systemName: "chevron.right")
                        }
                )
            }
            .padding(.bottom, 4)
            
            Spacer().frame(height: 24)
            
            let weekdaySymbols = calendar.shortWeekdaySymbols
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                ForEach(weekdaySymbols, id: \.self) { symbol in
                    Text(symbol)
                        .font(.PCaption)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
            
            let days = generateDays()
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 8) {
                ForEach(days, id: \.self) { date in
                    if calendar.isDate(date, equalTo: Date.distantPast, toGranularity: .day) {
                        Text(" ")
                    } else {
                        let isSelected = calendar.isDate(date, inSameDayAs: selectedDate)
                        let isHighlighted = datesToHighlight.contains { calendar.isDate($0, inSameDayAs: date) }

                        Text("\(calendar.component(.day, from: date))")
                            .frame(maxWidth: .infinity)
                            .padding(6)
                            .background(
                                Circle().fill(
                                    isSelected ? Color.accentColor :
                                        (isHighlighted ? Color.accentColor.opacity(0.3) : .clear)
                                )
                            )
                            .foregroundColor(isSelected ? .white : .primary)
                            .onTapGesture {
                                selectedDate = date
                            }
                    }
                }
            }
        }
        
    }
    
    private func generateDays() -> [Date] {
        guard let monthInterval = calendar.dateInterval(of: .month, for: calendarMonth),
              let firstWeekday = calendar.dateComponents([.weekday], from: monthInterval.start).weekday
        else { return [] }
        
        let daysInMonth = calendar.range(of: .day, in: .month, for: calendarMonth)!.count
        let offset = firstWeekday - calendar.firstWeekday
        
        var dates: [Date] = []
        for index in 0..<(daysInMonth + offset) {
            if index < offset {
                dates.append(.distantPast)
            } else {
                let date = calendar.date(byAdding: .day, value: index - offset, to: monthInterval.start)!
                dates.append(date)
            }
        }
        return dates
    }
}
