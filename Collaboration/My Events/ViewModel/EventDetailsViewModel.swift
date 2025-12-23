//
//  EventDetailsViewModel.swift
//  Collaboration
//
//  Created by Rize on 23.12.25.
//


import Foundation
import Combine


class EventDetailsViewModel: ObservableObject {
    @Published var event: Event?
    @Published var isLoading: Bool = false
    @Published var isRegistering: Bool = false
    @Published var showRegistrationSuccess: Bool = false
    @Published var errorMessage: String?
    
    private let eventId: String
    private let service = MockEventService.shared
    private var registrationId: String?
    
    init(eventId: String = "1") {
        self.eventId = eventId
        loadEvent()
    }
    
    
    func loadEvent() {
        isLoading = true
        errorMessage = nil
        
        service.fetchEventDetails(eventId: eventId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let event):
                self.event = event
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
            
            self.isLoading = false
        }
    }
    
    func registerForEvent() {
        guard let event = event else { return }
        guard !isRegistering else { return }
        guard event.spotsLeft > 0 else {
            errorMessage = "No spots available"
            return
        }
        
        isRegistering = true
        errorMessage = nil
        
        service.registerForEvent(eventId: eventId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let registrationId):
                self.registrationId = registrationId
                self.showRegistrationSuccess = true
                self.loadEvent()
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
            
            self.isRegistering = false
        }
    }
    
    func cancelRegistration() {
        guard let registrationId = registrationId else {
            showRegistrationSuccess = false
            return
        }
        
        service.cancelRegistration(eventId: eventId, registrationId: registrationId) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success:
                self.showRegistrationSuccess = false
                self.registrationId = nil
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    func dismissError() {
        errorMessage = nil
    }
    
    
    func shareEvent() {
        guard let event = event else { return }
        print("Sharing event: \(event.title)")
    }
    
    func addToCalendar() {
        guard let event = event else { return }
        print("Adding event to calendar: \(event.title)")
    }
    
    func canRegister() -> Bool {
        guard let event = event else { return false }
        return event.spotsLeft > 0 && !isRegistering
    }
}
