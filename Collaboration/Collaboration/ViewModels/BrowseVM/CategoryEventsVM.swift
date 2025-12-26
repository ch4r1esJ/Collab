//
//  CategoryEventsVM.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class CategoryEventsVM: ObservableObject {
    @Published var events: [EventListDto] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let eventService: EventServiceProtocol
    
    init(eventService: EventServiceProtocol = AppConfig.makeEventService()) {
        self.eventService = eventService
    }
    
    func fetchEvents(categoryId: Int) async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let allEvents = try await eventService.getEvents(
                eventTypeId: categoryId,
                location: nil,
                searchKeyword: nil,
                onlyAvailable: nil
            )
            
            guard !Task.isCancelled else {
                isLoading = false
                return
            }
            
            self.events = allEvents
        } catch is CancellationError {
        } catch let error as APIError {
            errorMessage = error.errorMessage
        } catch {
            errorMessage = "Failed to load events"
        }
        
        isLoading = false
    }
}
