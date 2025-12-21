//
//  AuthCoordinator.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI

struct AuthView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
            NavigationStack {
                SignInView()
            }
            .environmentObject(coordinator)
        }
}
