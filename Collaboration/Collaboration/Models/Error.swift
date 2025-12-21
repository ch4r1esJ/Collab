//
//  AuthResponse.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/20/25.
//

import Foundation


// MARK: - Error Response
struct ErrorResponse: Decodable {
    let message: String
    let errorCode: String?
    let statusCode: Int?
    let timestamp: String?
    let details: [String: [String]]?
}

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case invalidEmail
    case invalidPassword
    case serverError(Int)
    case decodingError
    case unauthorized
    case notFound
    case noData
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .invalidEmail:
            return "Please enter a valid email address"
        case .invalidPassword:
            return "Password must be at least 6 characters"
        case .serverError(let code):
            return "Server error with code: \(code)"
        case .decodingError:
            return "Failed to decode response"
        case .unauthorized:
            return "Unauthorized. Please login again."
        case .notFound:
            return "Resource not found"
        case .noData:
            return "No data received from server"
        }
    }
}
