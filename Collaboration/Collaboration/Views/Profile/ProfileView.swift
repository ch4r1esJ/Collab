//
//  ProfileView.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/22/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showLogoutAlert = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 16) {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray.opacity(0.3))
                        .background(Circle().stroke(Color.gray.opacity(0.2), lineWidth: 1))
                    
                    VStack(spacing: 4) {
                        Text(coordinator.currentUser?.fullName ?? "User")
                            .font(.system(size: 24, weight: .bold))
                        
                        Text(coordinator.currentUser?.isAdmin == true ? "Admin" : "Employee")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top, 40)
                .padding(.bottom, 30)
                
                List {
                    Section(header: Text("Account Information")) {
                        InformationRow(icon: "envelope", title: "Email", value: coordinator.currentUser?.email ?? "Department")
                        InformationRow(
                            icon: "building.2",
                            title: "Department",
                            value: coordinator.currentUser?.department ?? "Department"
                        )
                    }
                    
                    Section {
                        Button(role: .destructive) {
                            showLogoutAlert = true
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                Text("Log Out")
                                Spacer()
                            }
                        }
                    }
                }
                .listStyle(.insetGrouped)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Log Out", isPresented: $showLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Log Out", role: .destructive) {
                    handleLogout()
                }
            } message: {
                Text("Are you sure you want to log out of your account?")
            }
        }
    }
    
    private func handleLogout() {
        coordinator.logout()
        print("User logged out")
    }
}

struct InformationRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 24)
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    ProfileView()
}
