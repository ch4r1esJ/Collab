//
//  CategoriesView.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI

struct CategorySection: View {
    let categories = [
        Category(name: "Team Building", iconName: "profile", eventCount: 12),
        Category(name: "Sports", iconName: "sport", eventCount: 8),
        Category(name: "Workshops", iconName: "workshop", eventCount: 18),
        Category(name: "Happy Fridays", iconName: "friday", eventCount: 4),
        Category(name: "Cultural", iconName: "laugh", eventCount: 6),
        Category(name: "Wellness", iconName: "wellness", eventCount: 9)
    ]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Browse by Category")
                .font(.system(size: 20, weight: .bold))
                .padding(.vertical, 20)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(categories) { category in
                    CategoryCard(category: category)
                }
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    CategorySection()
}
