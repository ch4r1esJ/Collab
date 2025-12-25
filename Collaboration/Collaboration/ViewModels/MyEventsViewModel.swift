//
//  MyEventsViewModel.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/25/25.
//

import Foundation
import Combine

@MainActor
class MyEventsViewModel: ObservableObject {
    
    @Published var userRegistrations: [UserRegistrationDto] = []
    @Published var eventDetails: [Int: EventListDto] = [:]
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var selectedDate: Date = Date()
    @Published var currentMonth: Date = Date()
    
    private let eventService: EventServiceProtocol
    private let tokenManager = TokenManager.shared
    
    init(eventService: EventServiceProtocol = AppConfig.makeEventService()) {
        self.eventService = eventService
    }
    
    func fetchMyEvents() async {
        guard !isLoading else { return }
        
        guard let userId = tokenManager.getUserId() else {
            errorMessage = "User not logged in"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let registrations = try await eventService.getUserRegistrations(userId: userId)
            
            guard !Task.isCancelled else {
                isLoading = false
                return
            }
            
            self.userRegistrations = registrations.filter { $0.statusName != "Cancelled" }
            
            await fetchEventDetails()
            
        } catch is CancellationError {
        } catch let error as APIError {
            errorMessage = error.errorMessage
        } catch {
            errorMessage = "Failed to load your events"
        }
        
        isLoading = false
    }
    
    func refresh() async {
        await fetchMyEvents()
    }
    
    func cancelRegistration(_ registration: UserRegistrationDto) async {
        isLoading = true
        errorMessage = nil
        
        do {
            try await eventService.unregisterFromEvent(eventId: registration.eventId)
            
            userRegistrations.removeAll { $0.id == registration.id }
            
        } catch let error as APIError {
            errorMessage = error.errorMessage
        } catch {
            errorMessage = "Failed to cancel registration"
        }
        
        isLoading = false
    }
    
    func selectDate(_ date: Date) {
        selectedDate = date
    }
    
    func previousMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    func nextMonth() {
        if let newMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    func hasEvent(on date: Date) -> Bool {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: date)
        return datesWithEvents.contains(components)
    }
    
    func isSelected(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
    
    func getEventDetails(for registration: UserRegistrationDto) -> EventListDto? {
        eventDetails[registration.eventId]
    }
    
    var nextUpcomingEvent: (registration: UserRegistrationDto, event: EventListDto)? {
        let now = Date()
        
        return userRegistrations
            .compactMap { registration -> (UserRegistrationDto, EventListDto, Date)? in
                guard let event = eventDetails[registration.eventId],
                      let date = parseDate(event.startDateTime) else { return nil }
                return (registration, event, date)
            }
            .filter { $0.2 > now }
            .sorted { $0.2 < $1.2 }
            .first
            .map { ($0.0, $0.1) }
    }
    
    var registrationsWithDetails: [(registration: UserRegistrationDto, event: EventListDto)] {
        userRegistrations.compactMap { registration in
            guard let event = eventDetails[registration.eventId] else { return nil }
            return (registration, event)
        }
        .sorted { (item1, item2) in
            guard let date1 = parseDate(item1.event.startDateTime),
                  let date2 = parseDate(item2.event.startDateTime) else {
                return false
            }
            return date1 < date2
        }
    }
    
    var eventsForSelectedDate: [(registration: UserRegistrationDto, event: EventListDto)] {
        registrationsWithDetails.filter { item in
            guard let eventDate = parseDate(item.event.startDateTime) else { return false }
            return Calendar.current.isDate(eventDate, inSameDayAs: selectedDate)
        }
    }
    
    var datesWithEvents: Set<DateComponents> {
        var dates = Set<DateComponents>()
        
        for item in registrationsWithDetails {
            guard let eventDate = parseDate(item.event.startDateTime) else { continue }
            
            if Calendar.current.isDate(eventDate, equalTo: currentMonth, toGranularity: .month) {
                let components = Calendar.current.dateComponents([.year, .month, .day], from: eventDate)
                dates.insert(components)
            }
        }
        
        return dates
    }
    
    var selectedDateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter.string(from: selectedDate)
    }
    
    var currentMonthString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentMonth)
    }
    
    private func fetchEventDetails() async {
        for registration in userRegistrations {
            if eventDetails[registration.eventId] != nil {
                continue
            }
            
            do {
                let event = try await eventService.getEventDetails(id: registration.eventId)
                
                guard !Task.isCancelled else { return }
                
                self.eventDetails[registration.eventId] = event
                
            } catch {
            }
        }
    }
    
    private func parseDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        return formatter.date(from: dateString)
    }
    
    func formatTime(_ dateString: String) -> (time: String, period: String) {
        guard let date = parseDate(dateString) else {
            return ("--:--", "")
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        let time = formatter.string(from: date)
        
        formatter.dateFormat = "a"
        let period = formatter.string(from: date)
        
        return (time, period)
    }
    
    func formatEventDate(_ startDateTime: String) -> String {
        guard let date = parseDate(startDateTime) else {
            return "Date TBD"
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy, h:mm a"
        return formatter.string(from: date)
    }
}

extension UserRegistrationDto {
    var statusColor: String {
        switch statusName.lowercased() {
        case "confirmed":
            return "green"
        case "waitlisted":
            return "orange"
        case "cancelled":
            return "red"
        default:
            return "gray"
        }
    }
    
    var displayStatus: String {
        statusName.capitalized
    }
}
