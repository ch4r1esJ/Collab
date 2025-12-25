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
    
    private static var registeredUsers: [String: RegisteredUser] = [:]
    
    private static var userEventRegistrations: Set<Int> = []
    
    private struct RegisteredUser {
        let email: String
        let password: String
        let firstName: String
        let lastName: String
        let userId: Int
    }
    
    public init() {}
    
    private func simulateNetworkDelay() async throws {
        try await Task.sleep(nanoseconds: UInt64.random(in: 500_000_000...1_500_000_000))
    }
    
    func login(email: String, password: String) async throws -> LoginResponse {
        try await simulateNetworkDelay()
        
        let registeredUser = Self.registeredUsers[email]
        
        let existingMockUser = mockData.mockUsers.first(where: { $0.email == email })
        
        if let registeredUser = registeredUser {
            guard registeredUser.password == password else {
                throw APIError.unauthorized
            }
            
            return LoginResponse(
                token: "mock_jwt_token_\(registeredUser.userId)_\(UUID().uuidString)",
                userId: registeredUser.userId,
                email: registeredUser.email,
                fullName: "\(registeredUser.firstName) \(registeredUser.lastName)",
                department: "Engineering",
                isAdmin: false,
                expiresAt: ISO8601DateFormatter().string(from: Date().addingTimeInterval(86400))
            )
        }
        
        guard let mockUser = existingMockUser else {
            throw APIError.unauthorized
        }
        
        return LoginResponse(
            token: "mock_jwt_token_\(mockUser.id)_\(UUID().uuidString)",
            userId: mockUser.id,
            email: mockUser.email,
            fullName: mockUser.fullName,
            department: mockUser.department,
            isAdmin: mockUser.isAdmin,
            expiresAt: ISO8601DateFormatter().string(from: Date().addingTimeInterval(86400))
        )
    }
    
    func register(email: String, password: String, firstName: String, lastName: String) async throws {
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
        
        if Self.registeredUsers[email] != nil {
            throw APIError.conflict("User with this email already exists")
        }
        
        if mockData.mockUsers.contains(where: { $0.email == email }) {
            throw APIError.conflict("User with this email already exists")
        }
        
        let newUserId = (mockData.mockUsers.map { $0.id }.max() ?? 0) + 1
        Self.registeredUsers[email] = RegisteredUser(
            email: email,
            password: password,
            firstName: firstName,
            lastName: lastName,
            userId: newUserId
        )
    }
    
    func sendPasswordResetLink(email: String) async throws {
        try await simulateNetworkDelay()
        
        guard mockData.mockUsers.contains(where: { $0.email == email }) else {
            throw APIError.notFound("User with this email not found")
        }
    }
    
    func getCurrentUser() async throws -> UserProfileDto {
        try await simulateNetworkDelay()
        
        return mockData.mockUsers[0]
    }
    
    func getUpcomingEvents() async throws -> [EventListDto] {
        try await simulateNetworkDelay()
        return mockData.getUpcomingEvents()
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
            events = events.filter { $0.availableSlots > 0 }
        }
        
        return events
    }
    
    func getEventDetails(id: Int) async throws -> EventListDto {
        try await simulateNetworkDelay()
        
        guard let event = mockData.getEventDetails(id: id) else {
            throw APIError.notFound("Event not found")
        }
        
        return event
    }
    
    func getEventTypes() async throws -> [EventTypeDto] {
        try await simulateNetworkDelay()
        return mockData.mockEventTypes
    }
    
    func createEvent(request: CreateEventRequest) async throws -> EventListDto {
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
        
        if request.minCapacity < 1 {
            throw APIError.badRequest(APIErrorResponse(
                message: "Validation failed",
                errorCode: "VALIDATION_ERROR",
                statusCode: 400,
                timestamp: ISO8601DateFormatter().string(from: Date()),
                details: ["Capacity": ["Capacity must be at least 1"]]
            ))
        }
        
        let newId = (mockData.mockEvents.map { $0.id }.max() ?? 0) + 1
        let eventType = mockData.mockEventTypes.first(where: { $0.id == request.eventTypeId })
        
        return EventListDto(
            id: newId,
            title: request.title,
            description: request.description ?? "No description provided",
            eventTypeName: "In-Person",
            categoryId: request.eventTypeId,
            categoryTitle: eventType?.name ?? "Unknown",
            startDateTime: request.startDateTime,
            endDateTime: request.endDateTime,
            registrationDeadline: request.registrationDeadline ?? request.startDateTime,
            location: request.location,
            venueName: request.venueName ?? "Main Venue",
            currentCapacity: 0,
            maxCapacity: request.maxCapacity,
            availableSlots: request.maxCapacity,
            eventStatus: "Available",
            autoApprove: true,
            imageUrl: request.imageUrl ?? "https://example.com/default-event.jpg",
            isVisible: true,
            tags: [],
            createdByName: "Current User",
            speakers: [],
            agenda: []
        )
    }
    
    func checkRegistration(eventId: Int) async throws -> RegistrationCheckDto {
        try await simulateNetworkDelay()
        
        let isRegistered = Self.userEventRegistrations.contains(eventId) ||
        mockData.mockUserRegistrations.contains(where: { $0.eventId == eventId })
        
        return RegistrationCheckDto(isRegistered: isRegistered)
    }
    
    func registerForEvent(eventId: Int, userId: Int) async throws -> RegistrationResponse {
        try await simulateNetworkDelay()
        
        guard let event = mockData.mockEvents.first(where: { $0.id == eventId }) else {
            throw APIError.notFound("Event not found")
        }
        
        if Self.userEventRegistrations.contains(eventId) {
            throw APIError.conflict("Already registered for this event")
        }
        
        if mockData.mockUserRegistrations.contains(where: { $0.eventId == eventId }) {
            throw APIError.conflict("Already registered for this event")
        }
        
        let status: String
        let position: Int?
        
        if event.availableSlots > 0 {
            status = "Confirmed"
            position = nil
        } else {
            status = "Waitlisted"
            position = event.currentCapacity - event.maxCapacity + 1
        }
        
        let registrationId = Int.random(in: 100...999)
        
        let registration = RegistrationDto(
            id: registrationId,
            eventId: eventId,
            eventTitle: event.title,
            userId: userId,
            userFullName: "Test User",
            statusName: status,
            registeredAt: ISO8601DateFormatter().string(from: Date())
        )
        
        Self.userEventRegistrations.insert(eventId)
        
        return RegistrationResponse(
            message: "Successfully registered for the event",
            registrationId: registrationId,
            status: status,
            registration: registration
        )
    }
    
    func unregisterFromEvent(eventId: Int) async throws {
        try await simulateNetworkDelay()
        
        Self.userEventRegistrations.remove(eventId)
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
    
    func getCategories() async throws -> [CategoryDto] {
        try await simulateNetworkDelay()
        
        return [
            CategoryDto(id: 1, title: "Team Building", totalEvents: 12),
            CategoryDto(id: 2, title: "Sports", totalEvents: 8),
            CategoryDto(id: 3, title: "Workshop", totalEvents: 18),
            CategoryDto(id: 4, title: "Training", totalEvents: 15),
            CategoryDto(id: 5, title: "Social", totalEvents: 10),
            CategoryDto(id: 6, title: "Cultural", totalEvents: 6),
            CategoryDto(id: 7, title: "Wellness", totalEvents: 9),
            CategoryDto(id: 8, title: "Networking", totalEvents: 5)
        ]
    }
}

struct EmptyResponse: Codable {}
