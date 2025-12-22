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
        UserProfileDto(id: 1, email: "john.doe@company.com", fullName: "John Doe", role: "Employee"),
        UserProfileDto(id: 2, email: "jane.smith@company.com", fullName: "Jane Smith", role: "Organizer"),
        UserProfileDto(id: 3, email: "admin@company.com", fullName: "Admin User", role: "Admin"),
        UserProfileDto(id: 4, email: "bob.wilson@company.com", fullName: "Bob Wilson", role: "Employee"),
        UserProfileDto(id: 5, email: "sarah.jones@company.com", fullName: "Sarah Jones", role: "Employee")
    ]
    
    let mockEventTypes: [EventTypeDto] = [
        EventTypeDto(id: 1, name: "Team Building", description: "Activities to strengthen team bonds"),
        EventTypeDto(id: 2, name: "Workshop", description: "Educational and skill development sessions"),
        EventTypeDto(id: 3, name: "Sports", description: "Physical activities and sports events"),
        EventTypeDto(id: 4, name: "Happy Friday", description: "End of week celebrations"),
        EventTypeDto(id: 5, name: "Cultural", description: "Cultural and diversity events"),
        EventTypeDto(id: 6, name: "Training", description: "Professional training sessions"),
        EventTypeDto(id: 7, name: "Social", description: "Social networking events")
    ]
    
    let mockTags: [String] = [
        "outdoor", "indoor", "free-food", "remote-friendly", 
        "family-friendly", "networking", "learning", "wellness"
    ]
    
    let mockEvents: [EventListDto] = [
        EventListDto(
            id: 1,
            title: "Annual Team Building Retreat",
            eventTypeName: "Team Building",
            startDateTime: "2024-12-28T09:00:00Z",
            location: "Mountain Resort, Gudauri",
            capacity: 50,
            confirmedCount: 35,
            isFull: false,
            imageUrl: "https://images.unsplash.com/photo-1511632765486-a01980e01a18",
            tags: ["outdoor", "team-building", "wellness"]
        ),
        EventListDto(
            id: 2,
            title: "iOS Development Workshop",
            eventTypeName: "Workshop",
            startDateTime: "2024-12-22T14:00:00Z",
            location: "Tech Hub, Office Floor 3",
            capacity: 30,
            confirmedCount: 30,
            isFull: true,
            imageUrl: "https://images.unsplash.com/photo-1517694712202-14dd9538aa97",
            tags: ["learning", "indoor"]
        ),
        EventListDto(
            id: 3,
            title: "Friday Pizza & Games Night",
            eventTypeName: "Happy Friday",
            startDateTime: "2024-12-27T18:00:00Z",
            location: "Main Office Lounge",
            capacity: 80,
            confirmedCount: 65,
            isFull: false,
            imageUrl: "https://images.unsplash.com/photo-1513104890138-7c749659a591",
            tags: ["free-food", "indoor", "networking"]
        ),
        EventListDto(
            id: 4,
            title: "Company Soccer Tournament",
            eventTypeName: "Sports",
            startDateTime: "2025-01-05T10:00:00Z",
            location: "City Sports Complex",
            capacity: 100,
            confirmedCount: 78,
            isFull: false,
            imageUrl: "https://images.unsplash.com/photo-1574629810360-7efbbe195018",
            tags: ["outdoor", "wellness"]
        ),
        EventListDto(
            id: 5,
            title: "Leadership Training Program",
            eventTypeName: "Training",
            startDateTime: "2025-01-15T09:00:00Z",
            location: "Conference Center, Tbilisi",
            capacity: 25,
            confirmedCount: 20,
            isFull: false,
            imageUrl: "https://images.unsplash.com/photo-1552664730-d307ca884978",
            tags: ["learning", "indoor"]
        ),
        EventListDto(
            id: 6,
            title: "New Year Celebration",
            eventTypeName: "Cultural",
            startDateTime: "2024-12-31T20:00:00Z",
            location: "Grand Hall, Radisson Blu",
            capacity: 200,
            confirmedCount: 180,
            isFull: false,
            imageUrl: "https://images.unsplash.com/photo-1467810563316-b5476525c0f9",
            tags: ["free-food", "networking", "family-friendly"]
        ),
        EventListDto(
            id: 7,
            title: "Yoga & Meditation Session",
            eventTypeName: "Sports",
            startDateTime: "2025-01-08T07:00:00Z",
            location: "Rooftop Garden, Office",
            capacity: 20,
            confirmedCount: 18,
            isFull: false,
            imageUrl: "https://images.unsplash.com/photo-1544367567-0f2fcb009e0b",
            tags: ["wellness", "outdoor"]
        ),
        EventListDto(
            id: 8,
            title: "Design Thinking Workshop",
            eventTypeName: "Workshop",
            startDateTime: "2025-01-20T10:00:00Z",
            location: "Innovation Lab, Floor 5",
            capacity: 15,
            confirmedCount: 15,
            isFull: true,
            imageUrl: "https://images.unsplash.com/photo-1531538606174-0f90ff5dce83",
            tags: ["learning", "indoor"]
        )
    ]
    
    func getEventDetails(id: Int) -> EventDetailsDto? {
        guard let event = mockEvents.first(where: { $0.id == id }) else { return nil }
        
        return EventDetailsDto(
            id: event.id,
            title: event.title,
            description: getMockDescription(for: id),
            eventTypeName: event.eventTypeName,
            startDateTime: event.startDateTime,
            endDateTime: getEndDateTime(for: event.startDateTime),
            location: event.location,
            capacity: event.capacity,
            imageUrl: event.imageUrl,
            confirmedCount: event.confirmedCount,
            waitlistedCount: getWaitlistedCount(for: id),
            isFull: event.isFull,
            tags: event.tags,
            createdBy: "Event Organizer"
        )
    }
    
    let mockUserRegistrations: [UserRegistrationDto] = [
        UserRegistrationDto(
            registrationId: 1,
            eventId: 1,
            eventTitle: "Annual Team Building Retreat",
            eventType: "Team Building",
            startDateTime: "2024-12-28T09:00:00Z",
            location: "Mountain Resort, Gudauri",
            status: "Confirmed",
            registeredAt: "2024-12-15T10:00:00Z"
        ),
        UserRegistrationDto(
            registrationId: 2,
            eventId: 3,
            eventTitle: "Friday Pizza & Games Night",
            eventType: "Happy Friday",
            startDateTime: "2024-12-27T18:00:00Z",
            location: "Main Office Lounge",
            status: "Confirmed",
            registeredAt: "2024-12-16T14:30:00Z"
        ),
        UserRegistrationDto(
            registrationId: 3,
            eventId: 8,
            eventTitle: "Design Thinking Workshop",
            eventType: "Workshop",
            startDateTime: "2025-01-20T10:00:00Z",
            location: "Innovation Lab, Floor 5",
            status: "Waitlisted",
            registeredAt: "2024-12-19T09:15:00Z"
        )
    ]
    
    private func getMockDescription(for id: Int) -> String {
        let descriptions = [
            1: "Join us for an unforgettable team building experience in the beautiful mountains of Gudauri. Activities include team challenges, outdoor adventures, and networking opportunities.",
            2: "Deep dive into iOS development with SwiftUI. Learn best practices, architecture patterns, and hands-on coding. Suitable for intermediate developers.",
            3: "Wind down the week with colleagues over pizza, board games, and casual conversations. Great opportunity to meet people from different departments.",
            4: "Annual inter-department soccer tournament. Form your team and compete for the championship trophy. All skill levels welcome!",
            5: "Comprehensive leadership training program designed for team leads and aspiring managers. Topics include communication, conflict resolution, and strategic thinking.",
            6: "Celebrate the New Year with the entire company! Dinner, entertainment, and surprises await. Family members are welcome to join.",
            7: "Start your day right with a rejuvenating yoga and meditation session. Professional instructor will guide beginners and experienced practitioners alike.",
            8: "Learn design thinking methodology through interactive exercises and real-world case studies. Perfect for product managers, designers, and developers."
        ]
        return descriptions[id] ?? "Join us for this exciting event!"
    }
    
    private func getEndDateTime(for startDateTime: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: startDateTime) {
            let endDate = date.addingTimeInterval(4 * 3600) 
            return formatter.string(from: endDate)
        }
        return startDateTime
    }
    
    private func getWaitlistedCount(for id: Int) -> Int {
        let waitlisted = [2: 5, 8: 3]
        return waitlisted[id] ?? 0
    }
}

extension MockDataManager {
    func searchEvents(keyword: String) -> [EventListDto] {
        return mockEvents.filter {
            $0.title.localizedCaseInsensitiveContains(keyword) ||
            $0.eventTypeName.localizedCaseInsensitiveContains(keyword) ||
            $0.location.localizedCaseInsensitiveContains(keyword)
        }
    }
    
    func filterEvents(by eventTypeId: Int) -> [EventListDto] {
        let eventTypeName = mockEventTypes.first(where: { $0.id == eventTypeId })?.name
        return mockEvents.filter { $0.eventTypeName == eventTypeName }
    }
    
    func getUpcomingEvents() -> [EventListDto] {
        let now = Date()
        let formatter = ISO8601DateFormatter()
        
        return mockEvents.filter { event in
            if let eventDate = formatter.date(from: event.startDateTime) {
                return eventDate > now
            }
            return false
        }.sorted { event1, event2 in
            let date1 = formatter.date(from: event1.startDateTime) ?? Date()
            let date2 = formatter.date(from: event2.startDateTime) ?? Date()
            return date1 < date2
        }
    }
    
    func getMyEvents(userId: Int) -> [UserRegistrationDto] {
        return mockUserRegistrations
    }
}
