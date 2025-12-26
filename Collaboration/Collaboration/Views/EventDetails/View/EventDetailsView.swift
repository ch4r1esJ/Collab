//
//  EventDetailsView.swift
//  Collaboration
//
//  Created by Rize on 23.12.25.
//

import SwiftUI

struct EventDetailsView: View {
    let eventId: Int
    @StateObject private var viewModel: EventDetailsViewModel
    
    init(eventId: Int) {
        self.eventId = eventId
        _viewModel = StateObject(wrappedValue: EventDetailsViewModel(eventId: eventId))
    }
    
    var body: some View {
        content
            .navigationTitle("Event Details")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.loadEvent()
            }
            .alert("Error", isPresented: .constant(viewModel.errorMessage != nil && !viewModel.isLoading)) {
                Button("OK") {
                    viewModel.dismissError()
                }
            } message: {
                if let error = viewModel.errorMessage {
                    Text(error)
                }
            }
    }
    
    private var content: some View {
        Group {
            if viewModel.isLoading {
                return AnyView(loadingView)
            } else if let event = viewModel.event {
                return AnyView(EventContentView(event: event, viewModel: viewModel))
            } else if viewModel.errorMessage != nil {
                return AnyView(errorView)
            } else {
                return AnyView(Text("Debug: Unknown state"))
            }
        }
    }
    
    private var loadingView: some View {
        ProgressView("Loading event...")
            .progressViewStyle(CircularProgressViewStyle())
    }
    
    private var errorView: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text(viewModel.errorMessage ?? "Something went wrong")
                .font(.headline)
            
            Button("Retry") {
                Task {
                    await viewModel.loadEvent()
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}
