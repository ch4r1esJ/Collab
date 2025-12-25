//
//  StatusLabel.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import SwiftUI

struct StatusLabel: View {
    let title: String
    let bgColor: Color
    
    var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(bgColor)
            .cornerRadius(6)
    }
}

