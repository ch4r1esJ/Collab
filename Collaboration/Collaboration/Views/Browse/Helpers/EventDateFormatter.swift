//
//  EventDateFormatter.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import Foundation

struct EventDateFormatter {
    
    static func monthAndDay(from dateString: String) -> (month: String, day: String) {
        let isoFormatter = ISO8601DateFormatter()
        
        guard let date = isoFormatter.date(from: dateString) else {
            return ("JAN", "01")
        }
        
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        
        let month = monthFormatter.string(from: date).uppercased()
        let day = dayFormatter.string(from: date)
        
        return (month, day)
    }
    
    static func timeRange(from dateString: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        
        guard let date = isoFormatter.date(from: dateString) else {
            return "Time TBD"
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return formatter.string(from: date)
    }
}
