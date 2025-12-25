//
//  TabView.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @StateObject private var homeViewModel = HomeViewModel()
    
    var body: some View {
        TabView {
            NavigationStack(path: $coordinator.path) {
                HomeView(viewModel: homeViewModel)
                    .navigationDestination(for: AppRoute.self) { route in
                        switch route {
                        case .allEvents:
                            EventsList(viewModel: homeViewModel)
                        case .signUp:
                            SignUpView()
                        case .login:
                            SignInView()
                        case .home:
                            EmptyView()
                        case .eventDetails(let eventId):
                            EventDetailsView(eventId: eventId)
                        }
                    }
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            
            BrowseEventsScreen()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
            
            MyEventsView()
                .tabItem {
                    Label("My Events", systemImage: "calendar")
                }
            
            NotificationsView()
                .tabItem {
                    Label("Updates", systemImage: "bell.fill")
                }
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
    }
}
