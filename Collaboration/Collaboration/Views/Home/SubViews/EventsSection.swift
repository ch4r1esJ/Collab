//
//  EventsSection.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI

struct EventsSection: View {
    let events: [Event] = [
        Event(id: "1", month: "Jan", day: "18", title: "Annual Team Building Summit", time: "08:00 AM - 05:00 PM", location: "Grand Conference Hall", description: "Join us for a full day of engaging activities and networking opportunities.", registeredCount: 102, spotsLeft: "8 spots left"),
        Event(id: "2", month: "Jan", day: "20", title: "Leadership Workshop", time: "02:00 PM - 04:30 PM", location: "Training Room B", description: "Enhance your leadership skills with this interactive workshop.", registeredCount: 28, spotsLeft: "2 spots left"),
        Event(id: "3", month: "Jan", day: "24", title: "Happy Friday: Game Night", time: "06:00 PM - 09:00 PM", location: "Recreation Lounge", description: "Unwind after a productive week with board games and video games.", registeredCount: 30, spotsLeft: "Full", isWaitlisted: true)
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Text("Upcoming Events")
                        .font(.system(size: 24, weight: .regular))
                    Spacer()
                    Button("View all") { }
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                VStack(spacing: 16) {
                    ForEach(events, id: \.self) { event in
                        EventCard(event: event)
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top)
        }
    }
}

