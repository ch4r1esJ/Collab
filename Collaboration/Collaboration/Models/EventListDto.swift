//
//  EventListDto.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//


// MARK: - Event List (for Browse screen)
struct EventListDto: Codable {
    let id: Int
    let title: String
    let eventTypeName: String
    let startDateTime: String
    let location: String
    let capacity: Int
    let confirmedCount: Int
    let isFull: Bool
    let imageUrl: String?
    let tags: [String]
}

// MARK: - Event Details (for Details screen)
struct EventDetailsDto: Codable {
    let id: Int
    let title: String
    let description: String
    let eventTypeName: String
    let startDateTime: String
    let endDateTime: String
    let location: String
    let capacity: Int
    let imageUrl: String?
    let confirmedCount: Int
    let waitlistedCount: Int
    let isFull: Bool
    let tags: [String]
    let createdBy: String 
}

// MARK: - Event Type (for filters)
struct EventTypeDto: Codable {
    let id: Int
    let name: String
    let description: String?
}
