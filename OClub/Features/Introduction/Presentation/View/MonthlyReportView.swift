//
//  MonthlyReportView.swift
//  O'Club
//
//  Created by 최효원 on 4/16/25.
//

import SwiftUI

struct MonthlyReportView: View {
    @State private var currentYear: Int = Calendar.current.component(.year, from: Date())
    @EnvironmentObject private var router: NavigationRouter
    
    private let reports: [Report] = [
        Report(date: Date(), author: "AM 2팀 최효원", fileUrl: ""),
        Report(date: Calendar.current.date(byAdding: .month, value: -2, to: Date())!, author: "AM 2팀 최효원", fileUrl: ""),
        Report(date: Calendar.current.date(byAdding: .year, value: -1, to: Date())!, author: "AM 2팀 최효원", fileUrl: "")
    ]
    
    var filteredReports: [Report] {
        reports.filter { Calendar.current.component(.year, from: $0.date) == currentYear }
    }
    
    var body: some View {
        ZStack {
            Color.allBackground.ignoresSafeArea()
            
            VStack {
                NavigationBar(
                    title: "월별 활동보고서",
                    rightButtonTitle: nil,
                    rightButtonAction: nil
                )
                
                yearNavigationBar
                
                if filteredReports.isEmpty {
                    Text("해당 연도의 활동보고서가 없습니다")
                        .foregroundStyle(.gray)
                        .padding()
                } else {
                    List(filteredReports) { report in
                        Button {
                            router.push(.reportDetail)
                        } label: {
                            ReportListRow(report: report)
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private var yearNavigationBar: some View {
        HStack(spacing: 20) {
            Button(
                action: {
                    currentYear -= 1
                }, label: {
                    Image(systemName: "chevron.left")
                }
            )
            Text("\(currentYear.description)년")
                .font(.PHeadline)
                .bold()
            
            Button(
                action: {
                    currentYear += 1
                }, label: {
                    Image(systemName: "chevron.right")
                }
            )
        }
        .foregroundStyle(.black)
        .padding(.top)
    }
}

struct ReportListRow: View {
    let report: Report
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(report.date.monthFormattedString) 활동보고서")
                .font(.PHeadline)
                .foregroundStyle(.black)
            Text(report.author)
                .font(.PSubhead)
                .foregroundStyle(Color.fontLightGray)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    MonthlyReportView()
}
