//
//  EventRegistration.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/24/25.
//

struct RegistrationResponse: Codable {
    let message: String
    let registrationId: Int
    let status: String
    let registration: RegistrationDto
}

struct RegistrationCheckDto: Codable {
    let isRegistered: Bool
}

struct RegistrationDto: Codable {
    let id: Int
    let eventId: Int
    let eventTitle: String
    let userId: Int
    let userFullName: String
    let statusName: String
    let registeredAt: String
    
    var registrationId: Int { id }
}

struct UserRegistrationDto: Codable, Identifiable {
    let id: Int
    let eventId: Int
    let eventTitle: String
    let userId: Int
    let userFullName: String
    let statusName: String
    let registeredAt: String
    
    var registrationId: Int { id }
    var status: String { statusName }
}

struct EventRegistrationDto: Codable {
    let registrationId: Int
    let userId: Int
    let userName: String
    let userEmail: String
    let status: String
    let registeredAt: String
}
