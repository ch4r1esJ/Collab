//
//  APIErrorResponse.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import Foundation

struct APIErrorResponse: Codable {
    let message: String
    let errorCode: String?
    let statusCode: Int
    let timestamp: String
    let details: [String: [String]]?
}

enum APIError: Error {
    case networkError(Error)
    case invalidResponse
    case unauthorized
    case notFound(String)
    case badRequest(APIErrorResponse)
    case conflict(String)
    case serverError(Int, String)
    case decodingError
    
    var errorMessage: String {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .unauthorized:
            return "Unauthorized. Please login again."
        case .notFound(let message):
            return message
        case .badRequest(let response):
            if let details = response.details, let firstError = details.values.first?.first {
                return firstError
            }
            return response.message
        case .conflict(let message):
            return message
        case .serverError(_, let message):
            return message
        case .decodingError:
            return "Failed to decode response"
        }
    }
    
    var validationErrors: [String: [String]]? {
        if case .badRequest(let response) = self {
            return response.details
        }
        return nil
    }
}
