//
//  Login.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/20/25.
//

import Foundation

struct LoginRequest: Codable {
    let email: String
    let password: String
//    let rememberMe: Bool
}

struct AuthResponse: Codable {
    let token: String
//    let user: User
//    let userId: String
}

struct LoginResponse: Codable {
    let token: String
    let userId: String
    let fullName: String
    let role: String
//    let expiresAt: String
}

struct User: Codable {
    let id: String
    let email: String
//    let firstName: String
//    let lastName: String
    var fullName: String /*{ "\(firstName) \(lastName)" }*/
    let role: String
//    let phoneNumber: String?
//    let department: String?
//    let isActive: Bool
//    let createdAt: Date
}

struct ForgotPasswordRequest: Codable {
    let email: String
}
