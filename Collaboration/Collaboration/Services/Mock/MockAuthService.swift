//
//  MockAuthService.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import Foundation

class MockAuthService: AuthServiceProtocol {
    private let tokenManager = TokenManager.shared
    
    private static var registeredUsers: [String: RegisteredUser] = [
        "user@example.com": RegisteredUser(
            email: "user@example.com",
            password: "password123",
            firstName: "Test",
            lastName: "User",
            phoneNumber: "+995555123456",
            departmentId: 1,
            userId: 1
        )
    ]
    
    private struct RegisteredUser {
        let email: String
        let password: String
        let firstName: String
        let lastName: String
        let phoneNumber: String
        let departmentId: Int
        let userId: Int
    }
    
    private func simulateNetworkDelay() async throws {
        try await Task.sleep(nanoseconds: UInt64.random(in: 500_000_000...1_500_000_000))
    }
    
    func register(
        email: String,
        password: String,
        firstName: String,
        lastName: String,
        phoneNumber: String,
        departmentId: Int
    ) async throws {
        try await simulateNetworkDelay()
        
        if email.isEmpty || !email.contains("@") {
            throw APIError.badRequest(APIErrorResponse(
                message: "Invalid email format",
                errorCode: "VALIDATION_ERROR",
                statusCode: 400,
                timestamp: ISO8601DateFormatter().string(from: Date()),
                details: ["email": ["Valid email is required"]]
            ))
        }
        
        if password.count < 8 {
            throw APIError.badRequest(APIErrorResponse(
                message: "Password too short",
                errorCode: "VALIDATION_ERROR",
                statusCode: 400,
                timestamp: ISO8601DateFormatter().string(from: Date()),
                details: ["password": ["Password must be at least 8 characters"]]
            ))
        }
        
        if phoneNumber.isEmpty {
            throw APIError.badRequest(APIErrorResponse(
                message: "Phone number is required",
                errorCode: "VALIDATION_ERROR",
                statusCode: 400,
                timestamp: ISO8601DateFormatter().string(from: Date()),
                details: ["phoneNumber": ["Phone number is required"]]
            ))
        }
        
        if Self.registeredUsers[email] != nil {
            throw APIError.conflict("User with this email already exists")
        }
        
        let userId = Self.registeredUsers.count + 1
        Self.registeredUsers[email] = RegisteredUser(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            departmentId: departmentId,
            userId: userId
        )
    }
    
    func login(email: String, password: String) async throws -> LoginResponse {
        try await simulateNetworkDelay()
        
        guard let user = Self.registeredUsers[email] else {
            throw APIError.unauthorized
        }
        
        guard user.password == password else {
            throw APIError.unauthorized
        }
        
        let token = "mock_jwt_token_\(user.userId)_\(UUID().uuidString)"
        let expiresAt = ISO8601DateFormatter().string(
            from: Date().addingTimeInterval(86400)
        )
        
        tokenManager.saveToken(token, expiresAt: expiresAt)
        
        return LoginResponse(
            token: token,
            userId: user.userId,
            email: user.email,
            fullName: "\(user.firstName) \(user.lastName)",
            department: getDepartmentName(id: user.departmentId),
            isAdmin: false,
            expiresAt: expiresAt
        )
    }
    
    func verifyOTP(code: String) async throws -> Bool {
        try await simulateNetworkDelay()
        return code == "111111"
    }
    
    func getDepartments() async throws -> [DepartmentDto] {
        try await simulateNetworkDelay()
        
        return [
            DepartmentDto(id: 1, name: "Engineering", description: "Software development and engineering"),
            DepartmentDto(id: 2, name: "Marketing", description: "Marketing and communications"),
            DepartmentDto(id: 3, name: "Sales", description: "Sales and business development"),
            DepartmentDto(id: 4, name: "HR", description: "Human resources"),
            DepartmentDto(id: 5, name: "Finance", description: "Finance and accounting"),
            DepartmentDto(id: 6, name: "Operations", description: "Operations and logistics"),
            DepartmentDto(id: 7, name: "General", description: "General staff")
        ]
    }
    
    func sendPasswordResetLink(email: String) async throws {
        try await simulateNetworkDelay()
        
        guard Self.registeredUsers[email] != nil else {
            throw APIError.notFound("User with this email not found")
        }
    }
    
    func getCurrentUser() async throws -> UserProfileDto {
        try await simulateNetworkDelay()
        
        guard let token = tokenManager.getToken() else {
            throw APIError.unauthorized
        }
        
        let components = token.components(separatedBy: "_")
        guard components.count > 2,
              let userIdString = components.dropFirst(2).first,
              let userId = Int(userIdString),
              let user = Self.registeredUsers.values.first(where: { $0.userId == userId }) else {
            throw APIError.unauthorized
        }
        
        return UserProfileDto(
            id: user.userId,
            email: user.email,
            fullName: "\(user.firstName) \(user.lastName)",
            department: getDepartmentName(id: user.departmentId),
            isAdmin: false
        )
    }
    
    private func getDepartmentName(id: Int) -> String {
        switch id {
        case 1: return "Engineering"
        case 2: return "Marketing"
        case 3: return "Sales"
        case 4: return "HR"
        case 5: return "Finance"
        case 6: return "Operations"
        case 7: return "General"
        default: return "General"
        }
    }
}
