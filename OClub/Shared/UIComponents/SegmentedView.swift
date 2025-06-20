//
//  SegmentedView.swift
//  O'Club
//
//  Created by 최효원 on 4/15/25.
//

import SwiftUI

struct SegmentedView: View {
    let segments: [String]
    @Binding var selected: String
    let onSelect: ((String) -> Void)?
    
    @Namespace private var animationNamespace
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(segments, id: \.self) { segment in
                Button(
                    action: {
                            selected = segment
                            onSelect?(segment)
                    },
                    label: {
                        VStack(spacing: 4) {
                            Text(segment)
                                .font(.PSubhead)
                                .fontWeight(.medium)
                                .foregroundColor(selected == segment ? .accentColor : Color(uiColor: .systemGray))
                            
                            Capsule()
                                .fill(Color.clear)
                                .frame(height: 4)
                            
                            if selected == segment {
                                Capsule()
                                    .fill(Color.accentColor)
                                    .frame(height: 4)
                                    .matchedGeometryEffect(id: "Tab", in: animationNamespace)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                )
            }
        }
        .padding()
    }
}
