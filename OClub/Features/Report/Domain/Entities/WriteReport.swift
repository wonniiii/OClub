//
//  Report.swift
//  O'Club
//
//  Created by 최효원 on 4/18/25.
//

import Foundation

struct WriteReport: Identifiable {
    var id = UUID()
    var summary: ActivitySummary
    var detailLogs: [DetailLog]
    var expenseUsages: [ExpenseUsage]
}

struct ActivitySummary: Identifiable {
    var id = UUID()
    var date: Date
    var location: String
    var peopleCount: Int
    var totalAmount: Int
    var clubFee: Int
    var companySupport: Int
}

struct DetailLog: Identifiable {
    var id = UUID()
    var date: Date
    var content: String
    var note: String
}

struct ExpenseUsage: Identifiable {
    var id = UUID()
    var date: Date
    var unitPrice: Int
    var quantity: Int
    var cardNumber: String
    var clubFeePayment: Int
}
