//
//  CardContainer.swift
//  O'Club
//
//  Created by 최효원 on 4/10/25.
//

import SwiftUI

struct CardContainerView<Content: View>: View {
    let desiredColor: Color
    let content: Content
    let onOverlayTap: () -> Void
    
    init(desiredColor: Color,
         onOverlayTap: @escaping () -> Void,
         @ViewBuilder content: () -> Content) {
        self.desiredColor = desiredColor
        self.onOverlayTap = onOverlayTap
        self.content = content()
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            CardBackground(desiredColor: desiredColor)
                .padding(.horizontal, 20)
                .shadow(radius: 3)
            content
            Button(action: onOverlayTap) {
                Text("View >")
                    .font(.PCaption).bold()
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .background(Color.black.opacity(0.9))
                    .foregroundColor(.white)
                    .clipShape(Capsule())
            }
            .padding(.trailing, 20)
        }
    }
}
