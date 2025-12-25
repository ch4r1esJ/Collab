//
//  MockEventService.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/23/25.
//

import Foundation

class MockEventService: EventServiceProtocol {
    private let mockAPI = MockAPIService.shared
    
    func checkRegistration(eventId: Int) async throws -> RegistrationCheckDto {
        try await mockAPI.checkRegistration(eventId: eventId)
    }
    
    func unregisterFromEvent(eventId: Int) async throws {
        try await mockAPI.unregisterFromEvent(eventId: eventId)
    }
    
    func getUpcomingEvents() async throws -> [EventListDto] {
        try await mockAPI.getUpcomingEvents()
    }
    
    func getEvents(
        eventTypeId: Int?,
        location: String?,
        searchKeyword: String?,
        onlyAvailable: Bool?
    ) async throws -> [EventListDto] {
        try await mockAPI.getEvents(
            eventTypeId: eventTypeId,
            location: location,
            searchKeyword: searchKeyword,
            onlyAvailable: onlyAvailable
        )
    }
    
    func getEventDetails(id: Int) async throws -> EventListDto {
        try await mockAPI.getEventDetails(id: id)
    }
    
    func getEventTypes() async throws -> [EventTypeDto] {
        try await mockAPI.getEventTypes()
    }
    
    func registerForEvent(eventId: Int, userId: Int) async throws -> RegistrationResponse {
        try await mockAPI.registerForEvent(eventId: eventId, userId: userId)
    }
    
    func getUserRegistrations(userId: Int) async throws -> [UserRegistrationDto] {
        try await mockAPI.getUserRegistrations(userId: userId)
    }
    
    func getEventRegistrations(eventId: Int) async throws -> [EventRegistrationDto] {
        try await mockAPI.getEventRegistrations(eventId: eventId)
    }
    
    func getCategories() async throws -> [CategoryDto] {
        try await mockAPI.getCategories()
    }
}
