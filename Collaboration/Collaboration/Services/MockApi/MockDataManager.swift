//
//  MockDataManager.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import Foundation

class MockDataManager {
    static let shared = MockDataManager()
    
    private init() {}
    
    let mockUsers: [UserProfileDto] = [
        
        UserProfileDto(id: 1, email: "Charles.Janjgava@gmail.com", fullName: "Charles Janjgava", department: "Employee", isAdmin: false),
        UserProfileDto(id: 2, email: "admin@gmail.com", fullName: "Charles Janjgava", department: "Employee", isAdmin: false),
        
    ]
    
    let mockEventTypes: [EventTypeDto] = [
        EventTypeDto(id: 1, name: "Team Building", description: "Activities to strengthen team bonds"),
        EventTypeDto(id: 2, name: "Sports", description: "Physical activities and sports events"),
        EventTypeDto(id: 3, name: "Workshop", description: "Educational and skill development sessions"),
        EventTypeDto(id: 4, name: "Training", description: "Professional training sessions"),
        EventTypeDto(id: 5, name: "Social", description: "Social networking events"),
        EventTypeDto(id: 6, name: "Cultural", description: "Cultural and diversity events"),
        EventTypeDto(id: 7, name: "Happy Friday", description: "End of week celebrations")
    ]
    
    let mockSpeakers: [SpeakerDto] = [
        SpeakerDto(id: 1, name: "John Smith", role: "Senior JavaScript Developer", photoUrl: "https://example.com/speakers/john-smith.jpg"),
        SpeakerDto(id: 2, name: "Sarah Johnson", role: "Tech Lead at Google", photoUrl: "https://example.com/speakers/sarah-johnson.jpg"),
        SpeakerDto(id: 3, name: "Robert Chen", role: "Database Architect", photoUrl: "https://example.com/speakers/robert-chen.jpg"),
        SpeakerDto(id: 4, name: "Michael Anderson", role: "Data Science Expert", photoUrl: "https://example.com/speakers/michael-anderson.jpg"),
        SpeakerDto(id: 5, name: "Emily Davis", role: "ML Engineer at Microsoft", photoUrl: "https://example.com/speakers/emily-davis.jpg")
    ]
    
    let mockEvents: [EventListDto] = [
        EventListDto(
            id: 1,
            title: "Annual Sports Tournament 2025",
            description: "Year-end sports competition with multiple teams",
            eventTypeName: "In-Person",
            categoryId: 2,
            categoryTitle: "Sports",
            startDateTime: "2025-12-28T09:00:00",
            endDateTime: "2025-12-28T17:00:00",
            registrationDeadline: "2025-12-25T23:59:59",
            location: "Main Office Building",
            venueName: "Sports Arena Complex",
            currentCapacity: 35,
            maxCapacity: 100,
            availableSlots: 65,
            eventStatus: "Registration Open",
            autoApprove: true,
            imageUrl: "https://example.com/sports.jpg",
            isVisible: true,
            tags: ["outdoor", "family-friendly"],
            createdByName: "Admin User",
            speakers: [],
            agenda: []
        )
    ]
    
    func getEventDetails(id: Int) -> EventListDto? {
        guard let event = mockEvents.first(where: { $0.id == id }) else { return nil }
        
        
        return EventListDto(
            id: event.id,
            title: event.title,
            description: event.description,
            eventTypeName: event.eventTypeName,
            categoryId: event.categoryId,
            categoryTitle: event.categoryTitle,
            startDateTime: event.startDateTime,
            endDateTime: event.endDateTime,
            registrationDeadline: event.registrationDeadline,
            location: event.location,
            venueName: event.venueName,
            currentCapacity: event.currentCapacity,
            maxCapacity: event.maxCapacity,
            availableSlots: event.availableSlots,
            eventStatus: event.eventStatus,
            autoApprove: event.autoApprove,
            imageUrl: event.imageUrl,
            isVisible: event.isVisible,
            tags: event.tags,
            createdByName: event.createdByName,
            speakers: event.speakers,
            agenda: event.agenda
        )
    }
    
    let mockUserRegistrations: [UserRegistrationDto] = [
        UserRegistrationDto(
            id: 1,
            eventId: 1,
            eventTitle: "Annual Sports Tournament 2025",
            userId: 1,
            userFullName: "Charles Janjgava",
            statusName: "Confirmed",
            registeredAt: "2025-12-15T10:00:00"
        )
    ]
}

extension MockDataManager {
    func searchEvents(keyword: String) -> [EventListDto] {
        return mockEvents.filter {
            $0.title.localizedCaseInsensitiveContains(keyword) ||
            $0.description.localizedCaseInsensitiveContains(keyword) ||
            $0.eventTypeName.localizedCaseInsensitiveContains(keyword) ||
            $0.location.localizedCaseInsensitiveContains(keyword)
        }
    }
    
    func filterEvents(by eventTypeId: Int) -> [EventListDto] {
        let eventTypeName = mockEventTypes.first(where: { $0.id == eventTypeId })?.name
        return mockEvents.filter { $0.categoryTitle == eventTypeName }
    }
    
    func getUpcomingEvents() -> [EventListDto] {
        let now = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        let filtered = mockEvents.filter { event in
            if let eventDate = formatter.date(from: event.startDateTime) {
                let isUpcoming = eventDate > now
                return isUpcoming
            } else {
                return false
            }
        }.sorted { event1, event2 in
            let date1 = formatter.date(from: event1.startDateTime) ?? Date()
            let date2 = formatter.date(from: event2.startDateTime) ?? Date()
            return date1 < date2
        }
        
        return filtered
    }
    
    func getMyEvents(userId: Int) -> [UserRegistrationDto] {
        return mockUserRegistrations
    }
}
