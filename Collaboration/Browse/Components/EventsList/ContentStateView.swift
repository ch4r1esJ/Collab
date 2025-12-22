//
//  ContentStateView.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct ContentStateView: View {
    let isLoading: Bool
    let events: [EventListDto]
    let error: String?
    let onRetry: () -> Void
    
    var body: some View {
        Group {
            if let errorMessage = error {
                ErrorStateView(message: errorMessage, onRetry: onRetry)
            } else if isLoading && events.isEmpty {
                LoadingStateView()
            } else if events.isEmpty {
                EmptyStateView()
            } else {
                EventsListView(events: events)
            }
        }
    }
}
