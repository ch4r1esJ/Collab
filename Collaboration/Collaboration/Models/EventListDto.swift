//
//  EventListDto.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import Foundation

struct EventListDto: Codable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let eventTypeName: String
    let categoryId: Int
    let categoryTitle: String
    let startDateTime: String
    let endDateTime: String
    let registrationDeadline: String
    let location: String
    let venueName: String
    let currentCapacity: Int
    let maxCapacity: Int
    let availableSlots: Int     
    let eventStatus: String
    let autoApprove: Bool
    let imageUrl: String
    let isVisible: Bool
    let tags: [String]
    let createdByName: String
    let speakers: [SpeakerDto]
    let agenda: [AgendaItemDto]
}

struct AgendaItemDto: Codable, Identifiable {
    let id: Int
    let time: String
    let title: String
    let description: String?
}

struct SpeakerDto: Codable, Identifiable {
    let id: Int
    let name: String
    let role: String
    let photoUrl: String?
}

struct EventTypeDto: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
}

struct CreateEventRequest: Encodable {
    let title: String
    let description: String?
    let eventTypeId: Int
    let startDateTime: String
    let endDateTime: String
    let registrationDeadline: String?
    let location: String
    let venueName: String?
    let minCapacity: Int
    let maxCapacity: Int
    let waitlistEnabled: Bool
    let waitlistCapacity: Int?
    let imageUrl: String?
}
