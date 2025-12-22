//
//  CategoryFilterRow.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct CategoryFilterRow: View {
    let categories: [EventTypeDto]
    @Binding var activeCategory: Int?
    let onSelect: (Int?) -> Void
    let onLongPress: ((EventTypeDto) -> Void)?
    
    init(
        categories: [EventTypeDto],
        activeCategory: Binding<Int?>,
        onSelect: @escaping (Int?) -> Void,
        onLongPress: ((EventTypeDto) -> Void)? = nil
    ) {
        self.categories = categories
        self._activeCategory = activeCategory
        self.onSelect = onSelect
        self.onLongPress = onLongPress
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                CategoryChip(
                    name: "All",
                    isActive: activeCategory == nil,
                    onTap: { onSelect(nil) }
                )
                
                ForEach(categories, id: \.id) { category in
                    CategoryChip(
                        name: category.name,
                        isActive: activeCategory == category.id,
                        onTap: { onSelect(category.id) },
                        onLongTap: onLongPress != nil ? { onLongPress?(category) } : nil  // ← onLongTap (არა onLongPress)
                    )
                }
            }
            .padding(.horizontal)
        }
        .padding(.bottom, 16)
    }
}
