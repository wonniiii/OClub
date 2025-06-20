//
//  NavigationBar.swift
//  O'Club
//
//  Created by 최효원 on 4/7/25.
//

import SwiftUI

struct NavigationBar: View {
    let title: String
    let rightButtonTitle: String?
    let rightButtonAction: (() -> Void)?
    var rightButtonColor: Color = .black
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            // 중앙 제목
            Text(title)
                .font(.PBody)
                .foregroundStyle(.black)
            
            // 좌우 버튼
            HStack {
                Button(
                    action: {
                        dismiss()
                    },
                    label: {
                        Image(systemName: "chevron.left")
                            .font(.PBody)
                            .foregroundStyle(.black)
                    }
                )
                
                Spacer()
                
                if let rightTitle = rightButtonTitle, let action = rightButtonAction {
                    Button(action: action) {
                        Text(rightTitle)
                            .font(.PBody)
                            .foregroundStyle(rightButtonColor)
                    }
                } else {
                    // 공간 확보용 투명 뷰
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 44, height: 44)
                }
            }
        }
        .frame(height: 44)
        .padding(.horizontal)
        .padding(.top, 12)
        .padding(.bottom, 6)
        .background(Color.white)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color.black.opacity(0.1)),
            alignment: .bottom
        )
    }
}
