//
//  UserProfileDto.swift
//  Collaboration
//
//  Created by Rize on 22.12.25.
//


import Foundation

// MARK: - User Models
struct UserProfileDto: Codable, Identifiable {
    let id: Int
    let email: String
    let fullName: String
    let role: String
}


// MARK: - Registration Models
struct RegistrationDto: Codable, Identifiable {
    let id: Int
    let eventId: Int
    let userId: Int
    let status: String
    let registeredAt: String
    let position: Int?
}

struct UserRegistrationDto: Codable, Identifiable {
    var id: Int { registrationId }
    let registrationId: Int
    let eventId: Int
    let eventTitle: String
    let eventType: String
    let startDateTime: String
    let location: String
    let status: String
    let registeredAt: String
}

struct EventRegistrationDto: Codable, Identifiable {
    var id: Int { registrationId }
    let registrationId: Int
    let userId: Int
    let userName: String
    let userEmail: String
    let status: String
    let registeredAt: String
}

