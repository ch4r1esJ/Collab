//
//  FilterToggleButton.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import SwiftUI

struct FilterToggleButton: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        Button(action: { isShowing.toggle() }) {
            HStack(spacing: 6) {
                Image(systemName: "slider.horizontal.3")
                Text("Filters")
            }
            .foregroundColor(.primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}


