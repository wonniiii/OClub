//
//  WriteReportViewModel.swift
//  O'Club
//
//  Created by 최효원 on 4/18/25.
//

import SwiftUI

final class ActivityViewModel: Observable {
    var activity: WriteReport = WriteReport(
        summary: ActivitySummary(
            date: .now,
            location: "",
            peopleCount: 0,
            totalAmount: 0,
            clubFee: 0,
            companySupport: 0
        ),
        detailLogs: [],
        expenseUsages: []
    )

    func addDetailLog() {
        activity.detailLogs.append(DetailLog(date: .now, content: "", note: ""))
    }

    func addExpenseUsage() {
        activity.expenseUsages.append(
            ExpenseUsage(date: .now, unitPrice: 0, quantity: 0, cardNumber: "", clubFeePayment: 0)
        )
    }
}
