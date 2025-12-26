//
//  EventsSection.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI

struct EventsSection: View {
    let events: [EventListDto]
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Upcoming Events")
                    .font(.system(size: 22, weight: .regular))
                Spacer()
                
                Button("View all") {
                    coordinator.navigate(to: .allEvents)
                }
                .foregroundColor(.blue)
            }
            .padding(.horizontal)
            
            VStack(spacing: 16) {
                ForEach(events, id: \.id) { event in
                    EventCard(event: event)
                }
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
}
