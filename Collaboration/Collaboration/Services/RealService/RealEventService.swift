//
//  RealEventService.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/23/25.
//

import Foundation

class RealEventService: EventServiceProtocol {
    private let baseURL = "http://63.178.226.237:3000"
    private let tokenManager = TokenManager.shared
    
    private func makeRequest<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        body: Encodable? = nil
    ) async throws -> T {
        guard let token = tokenManager.getToken() else {
            throw APIError.unauthorized
        }
        
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw APIError.invalidResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
        case 401:
            throw APIError.unauthorized
        case 404:
            throw APIError.notFound("Resource not found")
        case 400:
            let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
            throw APIError.badRequest(errorResponse ?? APIErrorResponse(
                message: "Bad request",
                errorCode: "BAD_REQUEST",
                statusCode: 400,
                timestamp: ISO8601DateFormatter().string(from: Date()),
                details: nil
            ))
        case 409:
            let errorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data)
            throw APIError.conflict(errorResponse?.message ?? "Conflict occurred")
        default:
            throw APIError.serverError(httpResponse.statusCode, "Server error occurred")
        }
    }
    
    func getUpcomingEvents() async throws -> [EventListDto] {
        try await makeRequest(endpoint: "/api/Events")
    }
    
    func getEvents(
        eventTypeId: Int? = nil,
        location: String? = nil,
        searchKeyword: String? = nil,
        onlyAvailable: Bool? = nil
    ) async throws -> [EventListDto] {
        var queryItems: [URLQueryItem] = []
        
        if let eventTypeId = eventTypeId {
            queryItems.append(URLQueryItem(name: "eventTypeId", value: "\(eventTypeId)"))
        }
        if let location = location {
            queryItems.append(URLQueryItem(name: "location", value: location))
        }
        if let searchKeyword = searchKeyword {
            queryItems.append(URLQueryItem(name: "searchKeyword", value: searchKeyword))
        }
        if let onlyAvailable = onlyAvailable {
            queryItems.append(URLQueryItem(name: "onlyAvailable", value: "\(onlyAvailable)"))
        }
        
        var components = URLComponents(string: "\(baseURL)/api/Events")!
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        
        guard let url = components.url else {
            throw APIError.invalidResponse
        }
        
        guard let token = tokenManager.getToken() else {
            throw APIError.unauthorized
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw APIError.invalidResponse
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return try decoder.decode([EventListDto].self, from: data)
    }
    
    func getEventDetails(id: Int) async throws -> EventListDto {
        try await makeRequest(endpoint: "/api/Events/\(id)")
    }
    
    func getEventTypes() async throws -> [EventTypeDto] {
        try await makeRequest(endpoint: "/api/Events/types")
    }
    
    func checkRegistration(eventId: Int) async throws -> RegistrationCheckDto {
        try await makeRequest(endpoint: "/api/Registration/check/\(eventId)")
    }
    
    func registerForEvent(eventId: Int, userId: Int) async throws -> RegistrationResponse {
        struct RegisterRequest: Encodable {
            let eventId: Int
        }
        
        return try await makeRequest(
            endpoint: "/api/Registration/register",
            method: "POST",
            body: RegisterRequest(eventId: eventId)
        )
    }
    
    func unregisterFromEvent(eventId: Int) async throws {
        struct UnregisterResponse: Codable {
            let message: String
        }
        
        let _: UnregisterResponse = try await makeRequest(
            endpoint: "/api/Registration/unregister/\(eventId)",
            method: "DELETE"
        )
    }
    
    func getUserRegistrations(userId: Int) async throws -> [UserRegistrationDto] {
        try await makeRequest(endpoint: "/api/Registration/my-registrations")
    }
    
    func getMyRegistrations() async throws -> [RegistrationDto] {
        try await makeRequest(endpoint: "/api/Registration/my-registrations")
    }
    
    func getEventRegistrations(eventId: Int) async throws -> [EventRegistrationDto] {
        try await makeRequest(endpoint: "/api/Registration/event/\(eventId)")
    }
    
    func getCategories() async throws -> [CategoryDto] {
        try await makeRequest(endpoint: "/api/Events/categories")
    }
    
    func getNotifications() async throws -> NotificationsResponse {
        try await makeRequest(endpoint: "/api/Notification/my-notifications")
    }

    func getUnreadCount() async throws -> UnreadCountResponse {
        try await makeRequest(endpoint: "/api/Notification/unread-count")
    }

    func markAsRead(notificationId: Int) async throws {
        struct EmptyResponse: Codable {}
        let _: EmptyResponse = try await makeRequest(
            endpoint: "/api/Notification/\(notificationId)/mark-as-read",
            method: "POST"
        )
    }

    func deleteNotification(notificationId: Int) async throws {
        struct EmptyResponse: Codable {}
        let _: EmptyResponse = try await makeRequest(
            endpoint: "/api/Notification/\(notificationId)",
            method: "DELETE"
        )
    }
}
