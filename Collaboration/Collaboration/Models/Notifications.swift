//
//  Notifications.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/26/25.
//

import Foundation

struct NotificationsResponse: Codable {
    let new: [NotificationDto]
    let earlier: [NotificationDto]
    let totalUnseenCount: Int
}

struct NotificationDto: Codable, Identifiable {
    let id: Int
    let title: String
    let message: String
    let type: String
    let eventId: Int?
    let eventTitle: String?
    let isSeen: Bool
    let createdAt: String
    
    var timeAgo: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSSSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSSS",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ss.SS",
            "yyyy-MM-dd'T'HH:mm:ss.S",
            "yyyy-MM-dd'T'HH:mm:ss"
        ]
        
        var date: Date?
        for format in formats {
            formatter.dateFormat = format
            if let parsedDate = formatter.date(from: createdAt) {
                date = parsedDate
                break
            }
        }
        
        guard let date = date else {
            return "Recently"
        }
        
        let now = Date()
        let components = Calendar.current.dateComponents([.second, .minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            if day == 1 {
                return "Yesterday"
            } else if day < 7 {
                return "\(day) days ago"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM d, yyyy"
                return dateFormatter.string(from: date)
            }
        } else if let hour = components.hour, hour > 0 {
            return "\(hour) hour\(hour == 1 ? "" : "s") ago"
        } else if let minute = components.minute, minute > 0 {
            return "\(minute) minute\(minute == 1 ? "" : "s") ago"
        } else {
            return "Just now"
        }
    }
    
    var icon: String {
        switch type {
        case "Registration":
            return "calendar"
        case "Unregistration":
            return "calendar.badge.minus"
        case "Welcome":
            return "hand.wave.fill"
        case "Reminder":
            return "bell.fill"
        case "Update":
            return "info.circle.fill"
        default:
            return "bell.fill"
        }
    }
}

struct UnreadCountResponse: Codable {
    let unreadCount: Int
}
