//
//  CollaborationApp.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/20/25.
//

import SwiftUI

@main
struct CollaborationApp: App {
    @StateObject private var authViewModel = AuthViewModel(authService: MockAuthService())
    
    var body: some Scene {
        WindowGroup {
            AppCoordinatorView()
        }
    }
}
