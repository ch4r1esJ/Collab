//
//  TitleLabel.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct TitleLabel: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.headline)
            .lineLimit(2)
    }
}

#Preview {
    TitleLabel(text: "Annual Team Building Summit")
}
