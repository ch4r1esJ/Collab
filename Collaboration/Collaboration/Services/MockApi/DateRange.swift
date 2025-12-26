//
//  DateRange.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import Foundation

enum DateRange: CaseIterable, Hashable {
    case all
    case today
    case thisWeek
    case thisMonth
    case nextMonth
    
    var displayName: String {
        switch self {
        case .all: return "All Dates"
        case .today: return "Today"
        case .thisWeek: return "This Week"
        case .thisMonth: return "This Month"
        case .nextMonth: return "Next Month"
        }
    }
    
    var dateInterval: DateInterval? {
        let calendar = Calendar.current
        let now = Date()
        
        switch self {
        case .all:
            return nil
            
        case .today:
            let startOfDay = calendar.startOfDay(for: now)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
            return DateInterval(start: startOfDay, end: endOfDay)
            
        case .thisWeek:
            let startOfWeek = calendar.dateInterval(of: .weekOfYear, for: now)?.start ?? now
            let endOfWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: startOfWeek)!
            return DateInterval(start: startOfWeek, end: endOfWeek)
            
        case .thisMonth:
            let startOfMonth = calendar.dateInterval(of: .month, for: now)?.start ?? now
            let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
            return DateInterval(start: startOfMonth, end: endOfMonth)
            
        case .nextMonth:
            let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: calendar.startOfDay(for: now))!
            let endOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfNextMonth)!
            return DateInterval(start: startOfNextMonth, end: endOfNextMonth)
        }
    }
}
