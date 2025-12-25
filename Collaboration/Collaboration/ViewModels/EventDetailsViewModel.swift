//
//  EventDetailsViewModel.swift
//  Collaboration
//
//  Created by Rize on 23.12.25.
//

import Foundation
import Combine

@MainActor
class EventDetailsViewModel: ObservableObject {
    @Published var event: EventListDto?
    @Published var isLoading: Bool = false
    @Published var isRegistering: Bool = false
    @Published var showRegistrationSuccess: Bool = false
    @Published var errorMessage: String?
    
    @Published var isRegistered: Bool = false
    
    private let eventId: Int
    private let eventService: EventServiceProtocol
    
    init(eventId: Int, eventService: EventServiceProtocol = AppConfig.makeEventService()) {
        self.eventId = eventId
        self.eventService = eventService
    }
    
    func loadEvent() async {
        guard !isLoading else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let eventDetails = try await eventService.getEventDetails(id: eventId)
            
            guard !Task.isCancelled else {
                isLoading = false
                return
            }
            
            self.event = eventDetails
            
            await checkRegistration()
            
        } catch {
            errorMessage = "Failed to load event details"
        }
        
        isLoading = false
    }
    
    func checkRegistration() async {
        do {
            let status = try await eventService.checkRegistration(eventId: eventId)
            
            guard !Task.isCancelled else { return }
            
            self.isRegistered = status.isRegistered
        } catch {
            self.isRegistered = false
        }
    }
    
    func registerForEvent() async {
        guard let event = event else { return }
        guard !isRegistering else { return }
        
        if isRegistered {
            errorMessage = "You are already registered for this event"
            return
        }
        
        guard event.availableSlots > 0 else {
            errorMessage = "No spots available"
            return
        }
        
        guard let userId = TokenManager.shared.getUserId() else {
            errorMessage = "Please log in to register"
            return
        }
        
        isRegistering = true
        errorMessage = nil
        
        do {
            let response = try await eventService.registerForEvent(eventId: eventId, userId: userId)
            
            guard !Task.isCancelled else {
                isRegistering = false
                return
            }
            
            self.isRegistered = true
            self.showRegistrationSuccess = true
            
            await loadEvent()
        } catch is CancellationError {
        } catch let error as APIError {
            errorMessage = error.errorMessage
        } catch {
            errorMessage = "Registration failed"
        }
        
        isRegistering = false
    }
    
    func unregisterFromEvent() async {
        guard !isRegistering else { return }
        
        isRegistering = true
        errorMessage = nil
        
        do {
            try await eventService.unregisterFromEvent(eventId: eventId)
            
            guard !Task.isCancelled else {
                isRegistering = false
                return
            }
            
            self.isRegistered = false
            
            await loadEvent()
        } catch is CancellationError {
        } catch let error as APIError {
            errorMessage = error.errorMessage
        } catch {
            errorMessage = "Unregister failed"
        }
        
        isRegistering = false
    }
    
    func cancelRegistration() {
        showRegistrationSuccess = false
    }
    
    func dismissError() {
        errorMessage = nil
    }
    
    func canRegister() -> Bool {
        guard let event = event else { return false }
        return !isRegistered && event.availableSlots > 0 && !isRegistering && event.isRegistrationOpen
    }
    
    func buttonState() -> RegistrationButtonState {
        if isRegistered {
            return .registered
        } else if event?.availableSlots == 0 {
            return .full
        } else {
            return .available
        }
    }
}

enum RegistrationButtonState {
    case available
    case registered
    case full
}

extension EventListDto {
    var spotsRemaining: Int {
        availableSlots
    }
    
    var timeRange: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let startDate = formatter.date(from: startDateTime),
              let endDate = formatter.date(from: endDateTime) else {
            return "Time TBD"
        }
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        let start = timeFormatter.string(from: startDate)
        let end = timeFormatter.string(from: endDate)
        
        return "\(start) - \(end)"
    }
    
    var registrationInfo: String {
        return "\(currentCapacity) registered • \(availableSlots) spot\(availableSlots == 1 ? "" : "s") left"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = formatter.date(from: startDateTime) else {
            return "Date TBD"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: date)
    }
    
    var isRegistrationOpen: Bool {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let deadline = formatter.date(from: registrationDeadline) else {
            return true
        }
        
        return Date() < deadline
    }
    
    var registrationDeadlineText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let deadline = formatter.date(from: registrationDeadline) else {
            return "No deadline"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy 'at' h:mm a"
        
        return "Registration closes on \(dateFormatter.string(from: deadline))"
    }
}
