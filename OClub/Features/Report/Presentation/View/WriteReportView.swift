//
//  ReportView.swift
//  O'Club
//
//  Created by 최효원 on 4/18/25.
//

import SwiftUI

struct WriteReportView: View {
    @State private var summaries: [ActivitySummary] = []
    @State private var logs: [DetailLog] = []
    @State private var expenses: [ExpenseUsage] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                ActivitySummaryTable(summaries: $summaries)
                DetailLogTable(logs: $logs)
                ExpenseUsageTable(expenses: $expenses)
            }
            .padding()
        }
    }
}

#Preview {
    WriteReportView()
}
