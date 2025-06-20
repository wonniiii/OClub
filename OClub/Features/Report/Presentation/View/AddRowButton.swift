//
//  File.swift
//  O'Club
//
//  Created by 최효원 on 4/18/25.
//

import SwiftUI

struct AddRowButton: View {
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Label("행 추가", systemImage: "plus")
                .padding(.vertical, 4)
        }
    }
}
