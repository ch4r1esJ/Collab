//
//  CategoryCard.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/22/25.
//

import SwiftUI

struct CategoryCard: View {
    let category: CategoryDto
    let iconName: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 35, height: 35)
            
            Text(category.title)
                .font(.system(size: 14, weight: .medium))
                .multilineTextAlignment(.center)
            
            Text("\(category.totalEvents) events")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
}
