//
//  WriteReportTable.swift
//  O'Club
//
//  Created by 최효원 on 4/18/25.
//

import SwiftUI

struct ActivitySummaryTable: View {
    @Binding var summaries: [ActivitySummary]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("활동 요약")
                .font(.PTitle3Bold)
                .padding(.bottom, 4)
            
            HStack {
                TableHeaderCell(text: "활동일")
                TableHeaderCell(text: "활동장소")
                TableHeaderCell(text: "인원수")
                TableHeaderCell(text: "총액")
                TableHeaderCell(text: "동아리비")
                TableHeaderCell(text: "기업지원")
            }
            
            Divider()
            
            ForEach($summaries) { $item in
                HStack {
                    DatePicker("", selection: $item.date, displayedComponents: .date)
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                    
                    TableRow(text: Binding(get: { item.location }, set: { item.location = $0 }))
                    TableRow(text: Binding(get: { "\(item.peopleCount)" }, set: { item.peopleCount = Int($0) ?? 0 }))
                    TableRow(text: Binding(get: { "\(item.totalAmount)" }, set: { item.totalAmount = Int($0) ?? 0 }))
                    TableRow(text: Binding(get: { "\(item.clubFee)" }, set: { item.clubFee = Int($0) ?? 0 }))
                    TableRow(text: Binding(get: { "\(item.companySupport)" }, set: { item.companySupport = Int($0) ?? 0 }))
                }
                Divider()
            }
            
            Button {
                summaries.append(ActivitySummary(date: Date(), location: "", peopleCount: 0, totalAmount: 0, clubFee: 0, companySupport: 0))
            } label: {
                Label("행 추가", systemImage: "plus")
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

struct DetailLogTable: View {
    @Binding var logs: [DetailLog]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("세부 내역")
                .font(.PTitle3Bold)
                .padding(.bottom, 4)
            
            HStack {
                TableHeaderCell(text: "활동일")
                TableHeaderCell(text: "활동 내역")
                TableHeaderCell(text: "특이사항")
            }
            
            Divider()
            
            ForEach($logs) { $log in
                HStack {
                    DatePicker("", selection: $log.date, displayedComponents: .date)
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                    
                    TableRow(text: Binding(get: { log.content }, set: { log.content = $0 }))
                    TableRow(text: Binding(get: { log.note }, set: { log.note = $0 }))
                }
                Divider()
            }
            
            Button {
                logs.append(DetailLog(date: Date(), content: "", note: ""))
            } label: {
                Label("행 추가", systemImage: "plus")
            }
            .padding(.top, 8)
        }
        .padding()
    }
}

struct ExpenseUsageTable: View {
    @Binding var expenses: [ExpenseUsage]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("경비 사용 내역")
                .font(.PTitle3Bold)
                .padding(.bottom, 4)
            
            HStack {
                TableHeaderCell(text: "활동일")
                TableHeaderCell(text: "단가")
                TableHeaderCell(text: "수량")
                TableHeaderCell(text: "법인카드 번호")
                TableHeaderCell(text: "동호회비 카드 결제 금액")
            }
            
            Divider()
            
            ForEach($expenses) { $item in
                HStack {
                    DatePicker("", selection: $item.date, displayedComponents: .date)
                        .labelsHidden()
                        .frame(maxWidth: .infinity)
                    
                    TableRow(text: Binding(get: { "\(item.unitPrice)" }, set: { item.unitPrice = Int($0) ?? 0 }))
                    TableRow(text: Binding(get: { "\(item.quantity)" }, set: { item.quantity = Int($0) ?? 0 }))
                    TableRow(text: Binding(get: { item.cardNumber }, set: { item.cardNumber = $0 }))
                    TableRow(text: Binding(get: { "\(item.clubFeePayment)" }, set: { item.clubFeePayment = Int($0) ?? 0 }))
                }
                Divider()
            }
            
            Button {
                expenses.append(ExpenseUsage(date: Date(), unitPrice: 0, quantity: 0, cardNumber: "", clubFeePayment: 0))
            } label: {
                Label("행 추가", systemImage: "plus")
            }
            .padding(.top, 8)
        }
        .padding()
    }
}
