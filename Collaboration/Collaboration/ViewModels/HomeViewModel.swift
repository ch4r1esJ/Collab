//
//  HomeViewModel.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/23/25.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    
    @Published var upcomingEvents: [EventListDto] = []
    @Published var trendingEvents: [EventListDto] = []
    @Published var categories: [EventTypeDto] = []
    @Published var categoryList: [CategoryDto] = []
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let eventService: EventServiceProtocol
    
    init(eventService: EventServiceProtocol = AppConfig.makeEventService()) {
        self.eventService = eventService
    }
    
    func fetchData() async {
        
        guard !isLoading else {
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let upcoming = try await eventService.getUpcomingEvents()
            
            guard !Task.isCancelled else {
                isLoading = false
                return
            }
            
            self.upcomingEvents = upcoming
            
            let cats = try await eventService.getCategories()
            
            guard !Task.isCancelled else {
                isLoading = false
                return
            }
            
            self.categoryList = cats
            
            let types = try await eventService.getEventTypes()
            
            guard !Task.isCancelled else {
                isLoading = false
                return
            }
            
            self.categories = types
            
            if upcoming.count >= 3 {
                let trendingIds = upcoming
                    .sorted { $0.currentCapacity > $1.currentCapacity }
                    .prefix(3)
                    .map { $0.id }
                
                await fetchTrendingEventDetails(ids: trendingIds)
            }
            
        } catch is CancellationError {
        } catch let error as APIError {
            errorMessage = error.errorMessage
        } catch {
            errorMessage = "Failed to load data"
        }
        
        isLoading = false
    }
    
    func refresh() async {
        await fetchData()
    }
    
    private func fetchTrendingEventDetails(ids: [Int]) async {
        var details: [EventListDto] = []
        
        for id in ids {
            guard !Task.isCancelled else {
                return
            }
            
            do {
                let detail = try await eventService.getEventDetails(id: id)
                details.append(detail)
            } catch is CancellationError {
                return
            } catch {
                continue
            }
        }
        
        guard !Task.isCancelled else {
            return
        }
        
        self.trendingEvents = details
    }
}
