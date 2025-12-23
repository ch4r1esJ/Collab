//
//  Event 2.swift
//  Collaboration
//
//  Created by Rize on 23.12.25.
//


import Foundation

struct Event {
    let id: String
    let title: String
    let description: String
    let bannerImageURL: String?
    let tags: [EventTag]
    let date: String
    let startTime: String
    let endTime: String
    let location: String
    let totalSpots: Int
    let registeredCount: Int
    let registrationDeadline: String
    let agenda: [AgendaItem]
    let speakers: [Speaker]
    
    var spotsLeft: Int {
        return totalSpots - registeredCount
    }
    
    var timeRange: String {
        return "\(startTime) - \(endTime)"
    }
    
    var registrationInfo: String {
        return "\(registeredCount) registered, \(spotsLeft) spots left"
    }
}

struct EventTag {
    let title: String
    let style: TagStyle
}

enum TagStyle {
    case light
    case dark
}