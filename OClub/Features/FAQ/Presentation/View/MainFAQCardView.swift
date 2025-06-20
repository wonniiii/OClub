//
//  MainFAQCardView.swift
//  O'Club
//
//  Created by 최효원 on 4/17/25.
//

import SwiftUI

struct MainFAQCardView: View {
    let item: MainFAQ
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: item.imageName)
                    .font(.PTitle2)
                    .foregroundStyle(item.foregroundColor)

                Text(item.title)
                    .font(.PFootnoteBold)
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
            }
            .padding(.vertical, 16)
            .padding(.leading, 16)
            .frame(width: 140, alignment: .leading)
            .background(item.backgroundColor)
            .cornerRadius(12)
            .shadow(radius: 2)
        }
    }
}
