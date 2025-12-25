//
//  CategoryFilterRow.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import SwiftUI

struct CategoryFilterRow: View {
    let categories: [CategoryDto]
    @Binding var activeCategory: Int?
    let onSelect: (Int?) -> Void
    let onLongPress: ((CategoryDto) -> Void)?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryPill(
                    title: "All",
                    isActive: activeCategory == nil,
                    action: { onSelect(nil) }
                )
                
                ForEach(categories, id: \.id) { category in
                    CategoryPill(
                        title: category.title,
                        isActive: activeCategory == category.id,
                        action: { onSelect(category.id) }
                    )
                    .onLongPressGesture {
                        onLongPress?(category)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
    }
}

struct CategoryPill: View {
    let title: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(isActive ? .white : .black)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(isActive ? Color.black : Color(red: 242/255, green: 242/255, blue: 247/255))
                .cornerRadius(20)
        }
    }
}
