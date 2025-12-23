//
//  EventDetailsView.swift
//  Collaboration
//
//  Created by Rize on 23.12.25.
//


import SwiftUI

struct EventDetailsView: View {
    @StateObject private var viewModel = EventDetailsViewModel()
    
    var body: some View {
        content
            .navigationTitle("Event Details")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Registration Successful", isPresented: $viewModel.showRegistrationSuccess) {
                Button("OK") {
                    viewModel.cancelRegistration()
                }
            } message: {
                Text("You have successfully registered for this event!")
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
                loadingView
            } else if let event = viewModel.event {
                EventContentView(event: event, viewModel: viewModel)
            } else if viewModel.errorMessage != nil {
                errorView
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
                viewModel.loadEvent()
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }
}
