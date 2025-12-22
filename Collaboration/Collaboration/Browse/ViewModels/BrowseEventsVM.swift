//
//  BrowseEventsVM.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import Foundation
import SwiftUI
import Combine

@MainActor
class BrowseEventsVM: ObservableObject {
    @Published var events: [EventListDto] = []
    @Published var categories: [EventTypeDto] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var searchQuery = ""
    @Published var activeCategory: Int?
    @Published var showingFilters = false
    
    @Published var showAvailableOnly = false
    @Published var locationText = ""
    @Published var dateRange: DateRange = .all
    
    private let apiService = MockAPIService.shared
    private var searchTask: Task<Void, Never>?
    
    var hasFiltersActive: Bool {
        showAvailableOnly || !locationText.isEmpty || dateRange != .all
    }
    
    var filtersActiveCount: Int {
        var count = 0
        if showAvailableOnly { count += 1 }
        if !locationText.isEmpty { count += 1 }
        if dateRange != .all { count += 1 }
        return count
    }
    
    func loadInitialData() async {
        await loadCategories()
        await fetchEvents()
    }
    
    func fetchEvents() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let results = try await apiService.getEvents(
                eventTypeId: activeCategory,
                location: locationText.isEmpty ? nil : locationText,
                searchKeyword: searchQuery.isEmpty ? nil : searchQuery,
                onlyAvailable: showAvailableOnly ? true : nil
            )
            events = results
        } catch {
            if let apiError = error as? APIError {
                errorMessage = apiError.errorMessage
            } else {
                errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
    
    private func loadCategories() async {
        do {
            categories = try await apiService.getEventTypes()
        } catch {
            print("Failed to load categories: \(error)")
        }
    }
    
    func selectCategory(_ id: Int?) {
        activeCategory = id
        Task {
            await fetchEvents()
        }
    }
    
    func updateSearch(_ query: String) {
        searchTask?.cancel()
        
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            
            guard !Task.isCancelled else { return }
            
            await fetchEvents()
        }
    }
    
    func applyFilters(_ filters: EventFilters) {
        Task {
            await fetchEvents()
        }
    }
    
    func clearFilters() {
        showAvailableOnly = false
        locationText = ""
        dateRange = .all
    }
    
    func buildFilters() -> EventFilters {
        EventFilters(
            showOnlyAvailable: showAvailableOnly ? true : nil,
            locationFilter: locationText.isEmpty ? nil : locationText,
            dateRangeFilter: dateRange != .all ? dateRange : nil,
            categoryId: activeCategory
        )
    }
    
    func reload() async {
        await fetchEvents()
    }
}
