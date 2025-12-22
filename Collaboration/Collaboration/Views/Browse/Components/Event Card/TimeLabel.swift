//
//  TimeLabel.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct TimeLabel: View {
    let startTime: String
    
    private var timeText: String {
        EventDateFormatter.timeRange(from: startTime)
    }
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "clock")
                .font(.caption)
            Text(timeText)
                .font(.caption)
        }
        .foregroundColor(.secondary)
    }
}

#Preview {
    TimeLabel(startTime: "2025-01-18T09:00:00Z")
}
