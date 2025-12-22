//
//  MockAPIService.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import Foundation
import SwiftUI

class MockAPIService {
    static let shared = MockAPIService()
    private let mockData = MockDataManager.shared
    
    private init() {}
    
    private func simulateNetworkDelay() async throws {
        try await Task.sleep(nanoseconds: UInt64.random(in: 500_000_000...1_500_000_000))
    }
    
    func login(email: String, password: String) async throws -> LoginResponse {
        try await simulateNetworkDelay()
        
        guard let user = mockData.mockUsers.first(where: { $0.email == email }) else {
            throw APIError.unauthorized
        }
        
        if password.isEmpty {
            throw APIError.badRequest(APIErrorResponse(
                message: "Password is required",
                errorCode: "VALIDATION_ERROR",
                statusCode: 400,
                timestamp: ISO8601DateFormatter().string(from: Date()),
                details: ["Password": ["Password cannot be empty"]]
            ))
        }
        
        return LoginResponse(
            token: "mock_jwt_token_\(user.id)_\(UUID().uuidString)",
            userId: user.id,
            fullName: user.fullName,
            role: user.role,
            expiresAt: ISO8601DateFormatter().string(from: Date().addingTimeInterval(86400))
        )
    }
    
    func register(email: String, password: String, fullName: String) async throws -> LoginResponse {
        try await simulateNetworkDelay()
        
        if mockData.mockUsers.contains(where: { $0.email == email }) {
            throw APIError.conflict("User with this email already exists")
        }
        
        if email.isEmpty || !email.contains("@") {
            throw APIError.badRequest(APIErrorResponse(
                message: "Invalid email format",
                errorCode: "VALIDATION_ERROR",
                statusCode: 400,
                timestamp: ISO8601DateFormatter().string(from: Date()),
                details: ["Email": ["Valid email is required"]]
            ))
        }
        
        if password.count < 8 {
            throw APIError.badRequest(APIErrorResponse(
                message: "Password too short",
                errorCode: "VALIDATION_ERROR",
                statusCode: 400,
                timestamp: ISO8601DateFormatter().string(from: Date()),
                details: ["Password": ["Password must be at least 8 characters"]]
            ))
        }
        
        let newUserId = (mockData.mockUsers.map { $0.id }.max() ?? 0) + 1
        
        return LoginResponse(
            token: "mock_jwt_token_\(newUserId)_\(UUID().uuidString)",
            userId: newUserId,
            fullName: fullName,
            role: "Employee",
            expiresAt: ISO8601DateFormatter().string(from: Date().addingTimeInterval(86400))
        )
    }
    
    func getCurrentUser() async throws -> UserProfileDto {
        try await simulateNetworkDelay()
        
        return mockData.mockUsers[0]
    }
    
    func getEvents(
        eventTypeId: Int? = nil,
        location: String? = nil,
        searchKeyword: String? = nil,
        onlyAvailable: Bool? = nil
    ) async throws -> [EventListDto] {
        try await simulateNetworkDelay()
        
        var events = mockData.mockEvents
        
        if let eventTypeId = eventTypeId {
            events = mockData.filterEvents(by: eventTypeId)
        }
        
        if let location = location {
            events = events.filter { $0.location.localizedCaseInsensitiveContains(location) }
        }
        
        if let keyword = searchKeyword, !keyword.isEmpty {
            events = mockData.searchEvents(keyword: keyword)
        }
        
        if let onlyAvailable = onlyAvailable, onlyAvailable {
            events = events.filter { !$0.isFull }
        }
        
        return events
    }
    
    func getEventDetails(id: Int) async throws -> EventDetailsDto {
        try await simulateNetworkDelay()
        
        guard let event = mockData.getEventDetails(id: id) else {
            throw APIError.notFound("Event not found")
        }
        
        return event
    }
    
    func getUpcomingEvents() async throws -> [EventListDto] {
        try await simulateNetworkDelay()
        return mockData.getUpcomingEvents()
    }
    
    func getEventTypes() async throws -> [EventTypeDto] {
        try await simulateNetworkDelay()
        return mockData.mockEventTypes
    }
    
    func createEvent(request: CreateEventRequest) async throws -> EventDetailsDto {
        try await simulateNetworkDelay()
        
        if request.title.isEmpty {
            throw APIError.badRequest(APIErrorResponse(
                message: "Validation failed",
                errorCode: "VALIDATION_ERROR",
                statusCode: 400,
                timestamp: ISO8601DateFormatter().string(from: Date()),
                details: ["Title": ["Title is required"]]
            ))
        }
        
        if request.capacity < 1 {
            throw APIError.badRequest(APIErrorResponse(
                message: "Validation failed",
                errorCode: "VALIDATION_ERROR",
                statusCode: 400,
                timestamp: ISO8601DateFormatter().string(from: Date()),
                details: ["Capacity": ["Capacity must be at least 1"]]
            ))
        }
        
        let newId = (mockData.mockEvents.map { $0.id }.max() ?? 0) + 1
        
        return EventDetailsDto(
            id: newId,
            title: request.title,
            description: request.description ?? "No description provided",
            eventTypeName: mockData.mockEventTypes.first(where: { $0.id == request.eventTypeId })?.name ?? "Unknown",
            startDateTime: request.startDateTime,
            endDateTime: request.endDateTime,
            location: request.location,
            capacity: request.capacity,
            imageUrl: request.imageUrl,
            confirmedCount: 0,
            waitlistedCount: 0,
            isFull: false,
            tags: [],
            createdBy: "Current User"
        )
    }
    
    func registerForEvent(eventId: Int, userId: Int) async throws -> RegistrationDto {
        try await simulateNetworkDelay()
        
        guard let event = mockData.mockEvents.first(where: { $0.id == eventId }) else {
            throw APIError.notFound("Event not found")
        }
        
        if mockData.mockUserRegistrations.contains(where: { $0.eventId == eventId }) {
            throw APIError.conflict("Already registered for this event")
        }
        
        let status: String
        let position: Int?
        
        if event.confirmedCount < event.capacity {
            status = "Confirmed"
            position = nil
        } else {
            status = "Waitlisted"
            position = event.confirmedCount - event.capacity + 1
        }
        
        return RegistrationDto(
            id: Int.random(in: 100...999),
            eventId: eventId,
            userId: userId,
            status: status,
            registeredAt: ISO8601DateFormatter().string(from: Date()),
            position: position
        )
    }
    
    func cancelRegistration(id: Int) async throws {
        try await simulateNetworkDelay()
        
        guard mockData.mockUserRegistrations.contains(where: { $0.registrationId == id }) else {
            throw APIError.notFound("Registration not found")
        }
    }
    
    func getUserRegistrations(userId: Int) async throws -> [UserRegistrationDto] {
        try await simulateNetworkDelay()
        return mockData.mockUserRegistrations
    }
    
    func getEventRegistrations(eventId: Int) async throws -> [EventRegistrationDto] {
        try await simulateNetworkDelay()
        
        return [
            EventRegistrationDto(
                registrationId: 1,
                userId: 1,
                userName: "John Doe",
                userEmail: "john.doe@company.com",
                status: "Confirmed",
                registeredAt: "2024-12-15T10:00:00Z"
            ),
            EventRegistrationDto(
                registrationId: 2,
                userId: 4,
                userName: "Bob Wilson",
                userEmail: "bob.wilson@company.com",
                status: "Confirmed",
                registeredAt: "2024-12-16T14:30:00Z"
            )
        ]
    }
    
    func sendPasswordResetLink(email: String) async throws {
        try await simulateNetworkDelay()
        
        guard mockData.mockUsers.contains(where: { $0.email == email }) else {
            throw APIError.notFound("User with this email not found")
        }
        
    }
}

struct EmptyResponse: Codable {}
