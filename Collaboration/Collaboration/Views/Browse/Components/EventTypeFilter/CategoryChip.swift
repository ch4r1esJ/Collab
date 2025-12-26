//
//  CategoryChip.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import SwiftUI

struct CategoryChip: View {
    let name: String
    let isActive: Bool
    let onTap: () -> Void
    let onLongTap: (() -> Void)?
    
    init(
        name: String,
        isActive: Bool,
        onTap: @escaping () -> Void,
        onLongTap: (() -> Void)? = nil
    ) {
        self.name = name
        self.isActive = isActive
        self.onTap = onTap
        self.onLongTap = onLongTap
    }
    
    var body: some View {
        Button(action: onTap) {
            Text(name)
                .font(.subheadline)
                .fontWeight(isActive ? .semibold : .regular)
                .foregroundColor(isActive ? .white : .primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isActive ? Color.black : Color(.systemGray6))
                .cornerRadius(20)
        }
        .simultaneousGesture(
            onLongTap != nil ? LongPressGesture(minimumDuration: 0.5)
                .onEnded { _ in
                    onLongTap?()
                } : nil
        )
    }
}
