//
//  MockEventService.swift
//  Collaboration
//
//  Created by Rize on 23.12.25.
//


import Foundation

class MockEventService {
    static let shared = MockEventService()
    
    private init() {}
    
    // MARK: - Fetch Event Details
    
    func fetchEventDetails(
        eventId: String,
        completion: @escaping (Result<Event, MockServiceError>) -> Void
    ) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Simulate different scenarios based on eventId
            switch eventId {
            case "404":
                completion(.failure(.eventNotFound))
            case "500":
                completion(.failure(.serverError))
            case "2":
                self.parseEventResponse(MockAPIResponses.eventDetailsFullyBooked, completion: completion)
            default:
                self.parseEventResponse(MockAPIResponses.eventDetailsSuccess, completion: completion)
            }
        }
    }
    
    // MARK: - Register for Event
    
    func registerForEvent(
        eventId: String,
        completion: @escaping (Result<String, MockServiceError>) -> Void
    ) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            // Simulate different scenarios
            let randomScenario = Int.random(in: 1...10)
            
            if randomScenario <= 8 {
                // 80% success rate
                self.parseRegistrationResponse(MockAPIResponses.registrationSuccess, completion: completion)
            } else if randomScenario == 9 {
                // 10% already registered
                completion(.failure(.alreadyRegistered))
            } else {
                // 10% no spots
                completion(.failure(.noSpotsAvailable))
            }
        }
    }
    
    // MARK: - Cancel Registration
    
    func cancelRegistration(
        eventId: String,
        registrationId: String,
        completion: @escaping (Result<Bool, MockServiceError>) -> Void
    ) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(true))
        }
    }
    
    // MARK: - Helper Methods
    
    private func parseEventResponse(
        _ jsonString: String,
        completion: @escaping (Result<Event, MockServiceError>) -> Void
    ) {
        guard let jsonData = jsonString.data(using: .utf8) else {
            completion(.failure(.invalidData))
            return
        }
        
        do {
            let response = try JSONDecoder().decode(EventResponse.self, from: jsonData)
            
            if response.success {
                let event = response.data.toEvent()
                completion(.success(event))
            } else {
                completion(.failure(.serverError))
            }
        } catch {
            completion(.failure(.decodingError))
        }
    }
    
    private func parseRegistrationResponse(
        _ jsonString: String,
        completion: @escaping (Result<String, MockServiceError>) -> Void
    ) {
        guard let jsonData = jsonString.data(using: .utf8) else {
            completion(.failure(.invalidData))
            return
        }
        
        do {
            let response = try JSONDecoder().decode(RegistrationResponse.self, from: jsonData)
            
            if response.success, let registrationId = response.registrationId {
                completion(.success(registrationId))
            } else {
                completion(.failure(.registrationFailed))
            }
        } catch {
            completion(.failure(.decodingError))
        }
    }
}

// MARK: - Mock Service Errors

enum MockServiceError: Error, LocalizedError {
    case eventNotFound
    case noSpotsAvailable
    case alreadyRegistered
    case registrationFailed
    case deadlinePassed
    case networkError
    case serverError
    case invalidData
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .eventNotFound:
            return "Event not found"
        case .noSpotsAvailable:
            return "No spots available for this event"
        case .alreadyRegistered:
            return "You are already registered for this event"
        case .registrationFailed:
            return "Registration failed. Please try again"
        case .deadlinePassed:
            return "Registration deadline has passed"
        case .networkError:
            return "Network connection error"
        case .serverError:
            return "Server error. Please try again later"
        case .invalidData:
            return "Invalid data received"
        case .decodingError:
            return "Failed to process data"
        }
    }
}