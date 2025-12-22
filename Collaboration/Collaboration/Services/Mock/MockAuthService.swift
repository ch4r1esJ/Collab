//
//  MockAuthService.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//
import Foundation

// Services/MockAuthService.swift
class MockAuthService: AuthServiceProtocol {
    
    func login(email: String, password: String) async throws -> LoginResponse {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        guard email.contains("@") else {
            throw NetworkError.invalidEmail
        }
        
        guard password.count >= 8 else {
            throw NetworkError.invalidPassword
        }
        
        if password == "wrong" {
            throw NetworkError.serverError(401)
        }
        
        return LoginResponse(
            token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mock_token_",
            userId: 123,
            fullName: "Bacho Jokhadze",
            role: "Employee",
            expiresAt: ISO8601DateFormatter().string(from: Date().addingTimeInterval(86400))
        )
    }
    
    func register(email: String, password: String, fullName: String) async throws -> LoginResponse {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        guard email.contains("@") else {
            throw NetworkError.invalidEmail
        }
        
        guard password.count >= 6 else {
            throw NetworkError.invalidPassword
        }
        
        guard !fullName.isEmpty else {
            throw NetworkError.invalidResponse
        }
        
        return LoginResponse(
            token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.mock_token_)",
            userId: Int.random(in: 100...999),
            fullName: fullName,
            role: "Employee",
            expiresAt: ISO8601DateFormatter().string(from: Date().addingTimeInterval(86400))
            )
    }
}
