//
//  EventServiceProtocol.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/23/25.
//

import Foundation

protocol EventServiceProtocol {
    func getUpcomingEvents() async throws -> [EventListDto]
    func getEvents(
        eventTypeId: Int?,
        location: String?,
        searchKeyword: String?,
        onlyAvailable: Bool?
    ) async throws -> [EventListDto]
    func getEventDetails(id: Int) async throws -> EventListDto
    
    func getEventTypes() async throws -> [EventTypeDto]
    func getCategories() async throws -> [CategoryDto]
    
    func registerForEvent(eventId: Int, userId: Int) async throws -> RegistrationResponse
    func checkRegistration(eventId: Int) async throws -> RegistrationCheckDto
    func unregisterFromEvent(eventId: Int) async throws
    
    func getUserRegistrations(userId: Int) async throws -> [UserRegistrationDto]
    func getEventRegistrations(eventId: Int) async throws -> [EventRegistrationDto]
}
