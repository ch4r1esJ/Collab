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
    @Published var allEvents: [EventListDto] = []
    @Published var categories: [CategoryDto] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    @Published var searchQuery = ""
    @Published var activeCategory: Int?
    @Published var showingFilters = false
    
    @Published var showAvailableOnly = false
    @Published var locationText = ""
    @Published var dateRange: DateRange = .all
    
    private let eventService: EventServiceProtocol
    private var searchTask: Task<Void, Never>?
    
    init(eventService: EventServiceProtocol = AppConfig.makeEventService()) {
        self.eventService = eventService
    }
    
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
            let results = try await eventService.getEvents(
                eventTypeId: nil,
                location: nil,
                searchKeyword: nil,
                onlyAvailable: nil
            )
            
            guard !Task.isCancelled else {
                isLoading = false
                return
            }
            
            allEvents = results
            applyClientSideFilters()
            
        } catch is CancellationError {
        } catch let error as APIError {
            errorMessage = error.errorMessage
        } catch {
            errorMessage = "Failed to load events"
        }
        
        isLoading = false
    }
    
    private func applyClientSideFilters() {
        var filtered = allEvents
        
        if let categoryId = activeCategory {
            filtered = filtered.filter { $0.categoryId == categoryId }
        }
        
        if !searchQuery.isEmpty {
            filtered = filtered.filter { event in
                event.title.localizedCaseInsensitiveContains(searchQuery) ||
                event.description.localizedCaseInsensitiveContains(searchQuery) ||
                event.location.localizedCaseInsensitiveContains(searchQuery)
            }
        }
        
        if showAvailableOnly {
            filtered = filtered.filter { $0.availableSlots > 0 }
        }
        
        if !locationText.isEmpty {
            filtered = filtered.filter { $0.location.localizedCaseInsensitiveContains(locationText) }
        }
        
        if dateRange != .all {
            filtered = filtered.filter { event in
                guard let eventDate = parseEventDate(event.startDateTime) else { return false }
                return isEventInDateRange(eventDate, range: dateRange)
            }
        }
        
        events = filtered
    }
    
    private func parseEventDate(_ dateString: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: dateString)
    }
    
    private func isEventInDateRange(_ eventDate: Date, range: DateRange) -> Bool {
        let now = Date()
        let calendar = Calendar.current
        
        switch range {
        case .all:
            return true
            
        case .today:
            return calendar.isDateInToday(eventDate)
            
        case .thisWeek:
            guard let weekStart = calendar.dateInterval(of: .weekOfYear, for: now)?.start,
                  let weekEnd = calendar.dateInterval(of: .weekOfYear, for: now)?.end else {
                return false
            }
            return eventDate >= weekStart && eventDate <= weekEnd
            
        case .thisMonth:
            guard let monthStart = calendar.dateInterval(of: .month, for: now)?.start,
                  let monthEnd = calendar.dateInterval(of: .month, for: now)?.end else {
                return false
            }
            return eventDate >= monthStart && eventDate <= monthEnd
            
        case .nextMonth:
            guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: now),
                  let monthStart = calendar.dateInterval(of: .month, for: nextMonth)?.start,
                  let monthEnd = calendar.dateInterval(of: .month, for: nextMonth)?.end else {
                return false
            }
            return eventDate >= monthStart && eventDate <= monthEnd
        }
    }
    
    private func loadCategories() async {
        do {
            categories = try await eventService.getCategories()
        } catch {
        }
    }
    
    func selectCategory(_ id: Int?) {
        activeCategory = id
        applyClientSideFilters()
    }
    
    func updateSearch(_ query: String) {
        searchTask?.cancel()
        
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            
            guard !Task.isCancelled else { return }
            
            applyClientSideFilters()
        }
    }
    
    func applyFilters(_ filters: EventFilters) {
        applyClientSideFilters()
    }
    
    func clearFilters() {
        showAvailableOnly = false
        locationText = ""
        dateRange = .all
        applyClientSideFilters()
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
