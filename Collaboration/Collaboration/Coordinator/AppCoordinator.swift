//
//  AppCoordinator.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI
import Combine
//
//enum AppRoute: Hashable {
//    case createAccount
//    case forgotPassword
//    
//    case eventDetails(eventID: String)
//    case filteredCategory(category: String)
//    
//    case notificationDetail(notificationID: String)
//}

@MainActor
class AppCoordinator: ObservableObject {
    @Published var isAuthenticated = false
    
    func login() {
        isAuthenticated = true
    }
    
    func logout() {
        isAuthenticated = false
    }
}

import SwiftUI

struct AppCoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        Group {
            if coordinator.isAuthenticated {
                MainTabView()
                    .environmentObject(coordinator)
            } else {
                AuthView()
                    .environmentObject(coordinator)
            }
        }
    }
}
