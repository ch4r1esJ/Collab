//
//  EventListDto.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

// MARK: - Event List (for Browse screen)
struct Event: Codable, Hashable {
    let id: String
    let month: String
    let day: String
    let title: String
    let time: String
    let location: String
    let description: String
    let registeredCount: Int
    let spotsLeft: String
    var isWaitlisted: Bool = false
    
    static let mockEvent = Event(
            id: "1",
            month: "DEC",
            day: "24",
            title: "Pied Piper Team Meeting",
            time: "10:00 AM - 12:00 PM",
            location: "TBC IT Academy, Tbilisi",
            description: "Year-end project review for the EventManagement app. We will discuss the MockAPI integration and final UI tweaks.",
            registeredCount: 8,
            spotsLeft: "2 spots left",
            isWaitlisted: false
        )
}

extension Event {
    static let mockEvents = [
        Event.mockEvent,
        Event(id: "2", month: "JAN", day: "05", title: "SwiftUI Workshop", time: "2:00 PM", location: "Online", description: "Deep dive into Protocols.", registeredCount: 15, spotsLeft: "Full", isWaitlisted: true),
        Event(id: "3", month: "JAN", day: "12", title: "iOS Developer Meetup", time: "6:00 PM", location: "Tech Hub", description: "Networking for junior devs.", registeredCount: 50, spotsLeft: "10 spots left", isWaitlisted: false)
    ]
}

// MARK: - Event Details (for Details screen)
//struct EventDetailsDto: Codable {
//    let id: Int
//    let title: String
//    let description: String
//    let eventTypeName: String
//    let startDateTime: String
//    let endDateTime: String
//    let location: String
//    let capacity: Int
//    let imageUrl: String?
//    let confirmedCount: Int
//    let waitlistedCount: Int
//    let isFull: Bool
//    let tags: [String]
//    let createdBy: String 
//}
//
//// MARK: - Event Type (for filters)
//struct EventTypeDto: Codable {
//    let id: Int
//    let name: String
//    let description: String?
//}

extension EventDetailsDto {
    static let mockTrendingEvents: [EventDetailsDto] = [
        EventDetailsDto(
            id: 101,
            title: "Tech Talk: AI in Business",
            description: "A deep dive into how Artificial Intelligence is transforming modern business workflows and decision-making processes.",
            eventTypeName: "Workshops",
            startDateTime: "2025-01-26T10:00:00Z",
            endDateTime: "2025-01-26T12:00:00Z",
            location: "Main Auditorium / Zoom",
            capacity: 50,
            imageUrl: "https://picsum.photos/id/1/600/400", 
            confirmedCount: 42,
            waitlistedCount: 0,
            isFull: false,
            tags: ["AI", "Tech", "Business"],
            createdBy: "HR Department"
        ),
        EventDetailsDto(
            id: 102,
            title: "Annual Hackathon 2025",
            description: "Our biggest coding event of the year! Form teams, solve problems, and win prizes. Food and drinks provided.",
            eventTypeName: "Cultural",
            startDateTime: "2025-02-10T09:00:00Z",
            endDateTime: "2025-02-12T18:00:00Z",
            location: "Innovation Hub",
            capacity: 100,
            imageUrl: "https://picsum.photos/id/2/600/400",
            confirmedCount: 100,
            waitlistedCount: 15,
            isFull: true, // Used to test "Full" and "Waitlist" UI states
            tags: ["Coding", "Collaboration", "Prizes"],
            createdBy: "Engineering Lead"
        ),
        EventDetailsDto(
            id: 103,
            title: "Product Design Sync",
            description: "Weekly sync for designers and developers to align on the new Employee Engagement Platform UI/UX components.",
            eventTypeName: "Team Building",
            startDateTime: "2025-03-15T14:00:00Z",
            endDateTime: "2025-03-15T15:30:00Z",
            location: "Room 404 & Microsoft Teams",
            capacity: 20,
            imageUrl: "https://picsum.photos/id/3/600/400",
            confirmedCount: 12,
            waitlistedCount: 0,
            isFull: false,
            tags: ["Design", "SwiftUI", "Sync"],
            createdBy: "Pied Piper Team"
        )
    ]
}
