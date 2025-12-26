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
    @Published var waitlistCount: Int = 0
    @Published var isRegistered: Bool = false
    @Published var registrationStatus: String?
    
    private let eventId: Int
    private let eventService: EventServiceProtocol
    
    init(eventId: Int, eventService: EventServiceProtocol = AppConfig.makeEventService()) {
        self.eventId = eventId
        self.eventService = eventService
    }
    
    func loadEvent() async {
        guard !isLoading else { return }
        
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
            await loadWaitlistCount()
            
        } catch {
            errorMessage = "Failed to load event details"
        }
        
        isLoading = false
    }
    
    func loadWaitlistCount() async {
        
        guard event?.eventStatus == "Waitlisted" || event?.availableSlots == 0 else {
            waitlistCount = 0
            return
        }
        
        do {
            let registrations = try await eventService.getEventRegistrations(eventId: eventId)
            
            
            guard !Task.isCancelled else { return }
            
            let waitlistedCount = registrations.filter { $0.statusName == "Waitlisted" }.count
            
            self.waitlistCount = waitlistedCount
        } catch {
            self.waitlistCount = 0
        }
    }
    
    func checkRegistration() async {
        do {
            let checkResult = try await eventService.checkRegistration(eventId: eventId)
            
            guard !Task.isCancelled else { return }
            
            if checkResult.isRegistered {
                let myRegistrations = try await eventService.getMyRegistrations()
                
                guard !Task.isCancelled else { return }
                
                if let registration = myRegistrations.first(where: { $0.eventId == eventId }) {
                    self.isRegistered = registration.statusName != "Cancelled"
                    self.registrationStatus = registration.statusName
                } else {
                    self.isRegistered = true
                    self.registrationStatus = "Confirmed"
                }
            } else {
                self.isRegistered = false
                self.registrationStatus = nil
            }
        } catch {
            self.isRegistered = false
            self.registrationStatus = nil
        }
    }
    
    func registerForEvent() async {
        guard let event = event else {
            return
        }
        guard !isRegistering else {
            return
        }
        
        if isRegistered {
            errorMessage = "You are already registered for this event"
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
            self.registrationStatus = response.status
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
            self.registrationStatus = nil
            
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
        return !isRegistered && !isRegistering && event.isRegistrationOpen
    }
    
    func buttonState() -> RegistrationButtonState {
        if isRegistered {
            if registrationStatus == "Waitlisted" {
                return .waitlisted
            } else if registrationStatus == "Confirmed" {
                return .registered
            } else {
                return event?.availableSlots == 0 ? .waitlist : .available
            }
        } else if event?.eventStatus == "Waitlisted" || event?.eventStatus == "Full" || event?.availableSlots == 0 {
            return .waitlist
        } else {
            return .available
        }
    }
}

enum RegistrationButtonState {
    case available
    case registered
    case waitlist
    case waitlisted
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
    
    func registrationInfo(waitlistCount: Int = 0) -> String {
        var info = "\(currentCapacity) registered"
        
        if availableSlots > 0 {
            info += " • \(availableSlots) spot\(availableSlots == 1 ? "" : "s") left"
        } else if waitlistCount > 0 {
            info += " • \(waitlistCount) on waitlist"
        } else {
            info += " • Full"
        }
        
        return info
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
