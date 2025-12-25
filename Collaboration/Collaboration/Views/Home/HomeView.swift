//
//  HomeView.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @ObservedObject var viewModel: HomeViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HeaderSection()
                
                if viewModel.isLoading && viewModel.upcomingEvents.isEmpty {
                    ProgressView("Loading events...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 12) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 40))
                            .foregroundColor(.orange)
                        Text(errorMessage)
                            .foregroundColor(.secondary)
                        Button("Retry") {
                            Task {
                                await viewModel.fetchData()
                            }
                        }
                    }
                    .padding()
                } else if viewModel.upcomingEvents.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "calendar.badge.exclamationmark")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No upcoming events")
                            .foregroundColor(.secondary)
                    }
                    .padding()
                } else {
                    EventsSection(events: Array(viewModel.upcomingEvents.prefix(3)))
                }
                
                if !viewModel.categoryList.isEmpty {
                    CategorySection(categories: viewModel.categoryList)
                }
                
                if !viewModel.trendingEvents.isEmpty {
                    TrendingEventsSection(events: viewModel.trendingEvents)
                }
                
                FAQSection()
            }
        }
        .onAppear {
            if viewModel.upcomingEvents.isEmpty && !viewModel.isLoading {
                Task {
                    await viewModel.fetchData()
                }
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
}

#Preview {
    NavigationStack {
        HomeView(viewModel: HomeViewModel())
            .environmentObject(AppCoordinator())
    }
}
