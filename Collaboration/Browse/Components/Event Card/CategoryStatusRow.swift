//
//  CategoryStatusRow.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct CategoryStatusRow: View {
    let categoryName: String
    let statusInfo: (label: String, color: Color)
    
    var body: some View {
        HStack {
            Text(categoryName)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
            
            StatusLabel(title: statusInfo.label, bgColor: statusInfo.color)
        }
    }
}


