//
//  AppCoordinator.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI
import Combine

enum AppRoute: Hashable {
    case login
    case signUp
    case home
    case allEvents
    case browseWithCategory(Int)
    case eventDetails(Int)
}

@MainActor
class AppCoordinator: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: UserProfileDto?
    @Published var isCheckingAuth = true
    
    @Published var path = NavigationPath()
    @Published var selectedBrowseCategory: Int?
    
    private let tokenManager = TokenManager.shared
    
    init() {
        checkAuthStatus()
    }
    
    func navigate(to route: AppRoute) {
        path.append(route)
    }
    
    func navigateToBrowseWithCategory(_ categoryId: Int) {
        selectedBrowseCategory = categoryId
        navigate(to: .browseWithCategory(categoryId))
    }
    
    func goBack() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func checkAuthStatus() {
        if let token = tokenManager.getToken(), !tokenManager.isTokenExpired() {
            currentUser = tokenManager.getUser()
            isAuthenticated = true
        }
        isCheckingAuth = false
    }
    
    func login(token: String, user: UserProfileDto, expiresAt: String) {
        tokenManager.saveToken(token, expiresAt: expiresAt)
        tokenManager.saveUser(user)
        currentUser = user
        isAuthenticated = true
    }
    
    func logout() {
        tokenManager.clearAll()
        path = NavigationPath()
        currentUser = nil
        isAuthenticated = false
    }
}

struct AppCoordinatorView: View {
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        Group {
            if coordinator.isCheckingAuth {
                ProgressView()
                    .scaleEffect(1.5)
            } else if coordinator.isAuthenticated {
                MainTabView()
                    .environmentObject(coordinator)
            } else {
                AuthView()
                    .environmentObject(coordinator)
            }
        }
    }
}
