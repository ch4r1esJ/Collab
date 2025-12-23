//
//  EventResponse.swift
//  Collaboration
//
//  Created by Rize on 23.12.25.
//


import Foundation


struct EventResponse: Codable {
    let success: Bool
    let data: EventData
    let message: String?
}

struct EventData: Codable {
    let id: String
    let title: String
    let description: String
    let bannerImageURL: String?
    let tags: [TagData]
    let date: String
    let startTime: String
    let endTime: String
    let location: String
    let totalSpots: Int
    let registeredCount: Int
    let registrationDeadline: String
    let agenda: [AgendaItemData]
    let speakers: [SpeakerData]
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case bannerImageURL = "banner_image_url"
        case tags
        case date
        case startTime = "start_time"
        case endTime = "end_time"
        case location
        case totalSpots = "total_spots"
        case registeredCount = "registered_count"
        case registrationDeadline = "registration_deadline"
        case agenda
        case speakers
    }
}

struct TagData: Codable {
    let title: String
    let style: String
}

struct AgendaItemData: Codable {
    let id: Int
    let time: String
    let title: String
    let description: String
}

struct SpeakerData: Codable {
    let id: String
    let name: String
    let title: String
    let imageName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case title
        case imageName = "image_name"
    }
}


struct RegistrationResponse: Codable {
    let success: Bool
    let message: String
    let registrationId: String?
    
    enum CodingKeys: String, CodingKey {
        case success
        case message
        case registrationId = "registration_id"
    }
}


struct EventErrorResponse: Codable {
    let success: Bool
    let error: String
    let code: Int
}
