//
//  EditableCell.swift
//  O'Club
//
//  Created by AM 2팀 최효원 on 4/18/25.
//

import SwiftUI

struct TableRow: View {
    @Binding var text: String
    var placeholder: String = ""
    
    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(.plain)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, alignment: .leading)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.2)),
                alignment: .bottom
            )
    }
}

struct TableHeaderCell: View {
    let text: String
    var body: some View {
        Text(text)
            .font(.PSubheadBold)
            .foregroundColor(.blue)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
