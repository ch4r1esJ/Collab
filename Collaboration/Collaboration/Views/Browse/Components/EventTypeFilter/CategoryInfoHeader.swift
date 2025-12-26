//
//  CategoryInfoHeader.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import SwiftUI

struct CategoryInfoHeader: View {
    let category: CategoryDto
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: categoryIcon(for: category.title))
                    .font(.title2)
                    .foregroundColor(.blue)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(category.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("\(category.totalEvents) events")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
        }
    }
    
    private func categoryIcon(for name: String) -> String {
        switch name.lowercased() {
        case "team building":
            return "person.3.fill"
        case "sports":
            return "sportscourt"
        case "workshop":
            return "hammer.fill"
        case "training":
            return "graduationcap.fill"
        case "social":
            return "party.popper.fill"
        case "cultural":
            return "theatermasks.fill"
        case "happy friday":
            return "star.fill"
        case "wellness":
            return "heart.fill"
        case "networking":
            return "person.2.fill"
        default:
            return "calendar"
        }
    }
}
