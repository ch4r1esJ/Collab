//
//  CategoryInfoHeader.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct CategoryInfoHeader: View {
    let category: EventTypeDto
    
    var body: some View {
        VStack(spacing: 8) {
            Text(category.name)
                .font(.title2)
                .fontWeight(.bold)
            
            if let info = category.description {
                Text(info)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
    }
}
