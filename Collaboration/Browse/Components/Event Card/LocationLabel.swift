//
//  LocationLabel.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct LocationLabel: View {
    let place: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "location")
                .font(.caption)
            Text(place)
                .font(.caption)
                .lineLimit(1)
        }
        .foregroundColor(.secondary)
    }
}


