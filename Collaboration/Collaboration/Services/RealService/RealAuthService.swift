//
//  RealAuthService.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/23/25.
//

import Foundation

class RealAuthService: AuthServiceProtocol {
    private let baseURL = "http://localhost:5282/api"
    private let tokenManager = TokenManager.shared
    
    private func makeRequest<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil,
        requiresAuth: Bool = false
    ) async throws -> T {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuth {
            guard let token = tokenManager.getToken() else {
                throw APIError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
            
        case 400:
            let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
            throw APIError.badRequest(errorResponse ?? APIErrorResponse(
                message: "Bad request",
                errorCode: "BAD_REQUEST",
                statusCode: 400,
                timestamp: ISO8601DateFormatter().string(from: Date()),
                details: nil
            ))
            
        case 401:
            throw APIError.unauthorized
            
        case 404:
            throw APIError.notFound("Resource not found")
            
        case 409:
            let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
            throw APIError.conflict(errorResponse?.message ?? "Conflict occurred")
            
        default:
            throw APIError.serverError(httpResponse.statusCode, "Server error occurred")
        }
    }
    
    private func makeVoidRequest(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil,
        requiresAuth: Bool = false
    ) async throws {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuth {
            guard let token = tokenManager.getToken() else {
                throw APIError.unauthorized
            }
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            request.httpBody = try encoder.encode(body)
        }
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
            
        case 400:
            let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
            throw APIError.badRequest(errorResponse ?? APIErrorResponse(
                message: "Bad request",
                errorCode: "BAD_REQUEST",
                statusCode: 400,
                timestamp: ISO8601DateFormatter().string(from: Date()),
                details: nil
            ))
            
        case 401:
            throw APIError.unauthorized
            
        case 404:
            throw APIError.notFound("Resource not found")
            
        case 409:
            let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
            throw APIError.conflict(errorResponse?.message ?? "Conflict occurred")
            
        default:
            throw APIError.serverError(httpResponse.statusCode, "Server error occurred")
        }
    }
    
    func register(email: String, password: String, firstName: String, lastName: String) async throws {
        let request = RegisterRequest(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName
        )
        
        try await makeVoidRequest(
            endpoint: "/Auth/register",
            method: "POST",
            body: request
        )
    }
    
    func login(email: String, password: String) async throws -> LoginResponse {
        let request = LoginRequest(email: email, password: password)
        
        let response: LoginResponse = try await makeRequest(
            endpoint: "/Auth/login",
            method: "POST",
            body: request
        )
        
        tokenManager.saveToken(response.token, expiresAt: response.expiresAt)
        
        return response
    }
    
    func verifyOTP(code: String) async throws -> Bool {
        let request = OTPRequest(code: code)
        
        let (data, response) = try await URLSession.shared.data(
            for: try createRequest(endpoint: "/Auth/check-otp", method: "POST", body: request)
        )
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        if let jsonString = String(data: data, encoding: .utf8),
           let isValid = Bool(jsonString) {
            return isValid
        }
        
        if let otpResponse = try? JSONDecoder().decode(OTPResponse.self, from: data) {
            return otpResponse.isValid
        }
        
        throw APIError.invalidResponse
    }
    
    func sendPasswordResetLink(email: String) async throws {
        let request = PasswordResetRequest(email: email)
        
        let _: PasswordResetResponse = try await makeRequest(
            endpoint: "/Auth/forgot-password",
            method: "POST",
            body: request
        )
    }
    
    func getCurrentUser() async throws -> UserProfileDto {
        return try await makeRequest(
            endpoint: "/Auth/me",
            method: "GET",
            requiresAuth: true
        )
    }
    
    private func createRequest(endpoint: String, method: String, body: Encodable?) throws -> URLRequest {
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        return request
    }
}
