//
//  Login.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/20/25.
//

import Foundation

struct LoginRequest: Encodable {
    let email: String
    let password: String
}

struct LoginResponse: Codable {
    let token: String
    let userId: Int
    let email: String
    let fullName: String
    let department: String
    let isAdmin: Bool
    let expiresAt: String
}

struct UserProfileDto: Codable {
    let id: Int
    let email: String
    let fullName: String
    let department: String
    let isAdmin: Bool
    
    var firstName: String {
        fullName.components(separatedBy: " ").first ?? fullName
    }
    
    var lastName: String {
        let components = fullName.components(separatedBy: " ")
        return components.count > 1 ? components.dropFirst().joined(separator: " ") : ""
    }
}

struct PasswordResetRequest: Encodable {
    let email: String
}

struct PasswordResetResponse: Codable {
    let message: String
}

struct ForgotPasswordRequest: Codable {
    let email: String
}
