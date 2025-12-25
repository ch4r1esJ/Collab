//
//  DateLabel.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import SwiftUI

struct DateLabel: View {
    let dateString: String
    
    private var parsedDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString) ?? Date()
    }
    
    private var month: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: parsedDate).uppercased()
    }
    
    private var day: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: parsedDate)
    }
    
    var body: some View {
        VStack(spacing: 4) {
            Text(month)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(day)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .frame(width: 50, height: 60)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}
