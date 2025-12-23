//
//  TabView.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI

struct MainTabView: View {
//    @EnvironmentObject var authViewModel: AuthViewModel
//    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            
            BrowseEventsScreen()
                .tabItem {
                    Label("Browse", systemImage: "magnifyingglass")
                }
            
            EventDetailsView()
                .tabItem {
                    Label("My Events", systemImage: "calendar")
                }
            
            NotificationsView()
                .tabItem {
                    Label("Updates", systemImage: "bell.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
