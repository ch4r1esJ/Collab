//
//  CategoriesView.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI

struct CategorySection: View {
    let categories: [CategoryDto]
    
    let columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    private func iconForCategory(_ title: String) -> String {
        switch title.lowercased() {
        case "team building":
            return "profile"
        case "sports":
            return "sport"
        case "workshop", "training":
            return "workshop"
        case "social":
            return "friday"
        case "cultural":
            return "laugh"
        case "wellness":
            return "wellness"
        case "networking":
            return "profile"
        default:
            return "profile"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Browse by Category")
                .font(.system(size: 20, weight: .bold))
                .padding(.vertical, 20)
            
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(categories) { category in
                    CategoryCard(
                        category: category,
                        iconName: iconForCategory(category.title)
                    )
                }
            }
        }
        .padding(.horizontal)
    }
}
