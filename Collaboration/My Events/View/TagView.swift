//
//  TagView.swift
//  Collaboration
//
//  Created by Rize on 23.12.25.
//


import SwiftUI

struct TagView: View {
    let tag: EventTag
    
    var body: some View {
        Text(tag.title)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(textColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
    
    private var backgroundColor: Color {
        switch tag.style {
        case .light:
            return .white
        case .dark:
            return .black
        }
    }
    
    private var textColor: Color {
        switch tag.style {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
}