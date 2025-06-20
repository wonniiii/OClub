//
//  ActionButton.swift
//  O'Club
//
//  Created by 최효원 on 4/8/25.
//

import SwiftUI

struct ActionButton: View {
    let title: String
    let action: () -> Void
    var heightRatio: CGFloat = 0.055
    var cornerRadius: CGFloat = 8
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .foregroundStyle(Color.white)
                .font(.PCalloutBold)
                .padding()
                .frame(maxWidth: .infinity)
                .frame(height: (UIScreen.current?.bounds.height)! * heightRatio)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))

        }
    }
}
