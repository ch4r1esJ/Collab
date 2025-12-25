//
//  EventsListView.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/23/25.
//

import SwiftUI

struct EventsList: View {
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        List(viewModel.upcomingEvents, id: \.id) { event in
            EventCard(event: event)
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .listStyle(.plain)
        .navigationTitle("Upcoming Events")
        .refreshable {
            await viewModel.refresh()
        }
    }
}
