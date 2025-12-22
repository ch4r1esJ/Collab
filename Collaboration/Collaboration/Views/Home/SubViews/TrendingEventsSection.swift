//
//  TrendingEventsSection.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/22/25.
//

import SwiftUI

struct TrendingEventsSection: View {
    let events: [EventDetailsDto]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Trending Events")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.vertical, 20)
                
                Text("Popular events with high registration rates.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(events, id: \.id) { event in
                        TrendingEventCard(event: event)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

#Preview {
    TrendingEventsSection(events: EventDetailsDto.mockTrendingEvents)
}
