//
//  HeaderSection.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//


import SwiftUI

struct HeaderSection: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            TitleView()
            
            Divider()
            
            WelcomeView(name: coordinator.currentUser?.firstName ?? "User")
        }
        .padding()
        .background(Color.white)
    }
}

struct WelcomeView: View {
    let name: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome back, \(name)")
                .font(.system(size: 25, weight: .medium))
            
            Text("Stay connected with upcoming company events and activities.")
                .font(.system(size: 18))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct TitleView: View {
    @StateObject private var notificationViewModel = NotificationsViewModel()
    @State private var showNotifications = false
    
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                Image("icon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                Text("EventHub")
                    .font(.system(size: 25, weight: .medium))
                    .padding(.bottom, 15)
            }
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: {
                    showNotifications = true
                }) {
                    Image(systemName: notificationViewModel.unreadCount > 0 ? "bell.badge.fill" : "bell")
                        .font(.system(size: 26))
                        .foregroundColor(.black)
                        .overlay(alignment: .topTrailing) {
                            if notificationViewModel.unreadCount > 0 {
                                ZStack {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 18, height: 18)
                                    
                                    Text("\(min(notificationViewModel.unreadCount, 99))")
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundColor(.white)
                                }
                                .offset(x: 8, y: -8)
                            }
                        }
                }
                
                Image("profileicon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
            }
        }
        .task {
            await notificationViewModel.loadUnreadCount()
        }
        .sheet(isPresented: $showNotifications) {
            NotificationsView()
        }
    }
}

#Preview {
    HeaderSection()
}
