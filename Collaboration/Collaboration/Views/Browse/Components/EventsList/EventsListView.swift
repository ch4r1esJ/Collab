//
//  EventsListView.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct EventsListView: View {
    let events: [EventListDto]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(events) { event in
                    EventItemCard(event: event)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
}
