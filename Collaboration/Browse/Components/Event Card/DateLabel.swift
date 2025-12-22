//
//  DateLabel.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct DateLabel: View {
    let dateString: String
    
    private var dateInfo: (month: String, day: String) {
        EventDateFormatter.monthAndDay(from: dateString)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(dateInfo.month)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            
            Text(dateInfo.day)
                .font(.title2)
                .fontWeight(.bold)
        }
        .frame(width: 60)
    }
}
