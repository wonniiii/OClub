//
//  ExpandableFAQView.swift
//  O'Club
//
//  Created by 최효원 on 4/17/25.
//

import SwiftUI

struct ExpandableFAQView: View {
    let item: FAQItem
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.question)
                    .font(.PSubheadBold)
                Spacer()
                Button(
                    action: {
                        isExpanded.toggle()
                    }, label: {
                        Image(systemName: isExpanded ? "minus" : "plus")
                            .imageScale(.medium)
                            .id(isExpanded)
                    }
                )
                .foregroundStyle(Color.cjRed)
                .animation(nil, value: isExpanded)
            }
            
            if isExpanded {
                Text(item.answer)
                    .font(.PFootnote)
                    .padding(.top, 4)
            }
        }
        .padding(20)
        .frame(height: isExpanded ? nil : 60)
        .background(Color.white)
        .cornerRadius(12)
    }
}
