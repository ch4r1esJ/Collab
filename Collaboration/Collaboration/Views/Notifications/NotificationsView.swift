//
//  NotificationsView.swift
//  Collaboration
//
//  Created by Rize on 25.12.25.
//

import SwiftUI
import Combine

struct NotificationsView: View {
    @StateObject private var viewModel = NotificationsViewModel()
    @State private var showDetailSheet = false
    @State private var selectedNotification: NotificationDto?
    @State private var navigateToEvent: Int?
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                NavigationHeader(
                    unreadCount: viewModel.unreadCount,
                    onBackTap: { dismiss() }
                )
                Divider().background(Color(red: 229/255, green: 229/255, blue: 234/255))
                TabBar(selectedTab: $viewModel.selectedTab, onTabChange: { tab in
                    viewModel.changeTab(to: tab)
                })
                Divider().background(Color(red: 229/255, green: 229/255, blue: 234/255))
                
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    NotificationsList(
                        newNotifications: viewModel.newNotifications,
                        earlierNotifications: viewModel.earlierNotifications,
                        showDetailSheet: $showDetailSheet,
                        selectedNotification: $selectedNotification,
                        onMarkAsRead: { id in
                            Task { await viewModel.markAsRead(id) }
                        }
                    )
                }
            }
            .background(Color(red: 242/255, green: 242/255, blue: 242/255))
            .navigationBarHidden(true)
            .navigationDestination(item: $navigateToEvent) { eventId in
                EventDetailsView(eventId: eventId)
            }
            .task {
                await viewModel.loadNotifications()
            }
            .sheet(item: $selectedNotification) { notification in
                NotificationDetailSheet(
                    notification: notification,
                    showSheet: Binding(
                        get: { selectedNotification != nil },
                        set: { if !$0 { selectedNotification = nil } }
                    ),
                    navigateToEvent: $navigateToEvent
                )
            }
        }
    }
}

struct NavigationHeader: View {
    let unreadCount: Int
    let onBackTap: () -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
                .frame(width: 44)
            
            Spacer()
            
            HStack(spacing: 8) {
                Text("Notifications")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
                
                if unreadCount > 0 {
                    Text("\(unreadCount)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.red)
                        .clipShape(Capsule())
                }
            }
            
            Spacer()
            
            Button(action: {}) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.black)
                    .rotationEffect(.degrees(90))
                    .frame(width: 44, height: 44)
            }
        }
        .frame(height: 56)
        .padding(.horizontal, 4)
        .background(Color.white)
    }
}

struct TabBar: View {
    @Binding var selectedTab: Int
    let onTabChange: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 0) {
            TabButton(title: "All", isSelected: selectedTab == 0, action: { onTabChange(0) })
            TabButton(title: "Registrations", isSelected: selectedTab == 1, action: { onTabChange(1) })
            TabButton(title: "Reminders", isSelected: selectedTab == 2, action: { onTabChange(2) })
            TabButton(title: "Updates", isSelected: selectedTab == 3, action: { onTabChange(3) })
        }
        .frame(height: 44)
        .background(Color.white)
    }
}

struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Text(title)
                    .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .black : Color(red: 142/255, green: 142/255, blue: 147/255))
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
                
                Rectangle()
                    .fill(isSelected ? Color.black : Color.clear)
                    .frame(height: 2)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct NotificationsList: View {
    let newNotifications: [NotificationDto]
    let earlierNotifications: [NotificationDto]
    @Binding var showDetailSheet: Bool
    @Binding var selectedNotification: NotificationDto?
    let onMarkAsRead: (Int) -> Void
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                if !newNotifications.isEmpty {
                    NewNotificationsSection(
                        notifications: newNotifications,
                        selectedNotification: $selectedNotification,
                        onMarkAsRead: onMarkAsRead
                    )
                }
                
                if !earlierNotifications.isEmpty {
                    EarlierNotificationsSection(
                        notifications: earlierNotifications,
                        selectedNotification: $selectedNotification
                    )
                }
                
                if newNotifications.isEmpty && earlierNotifications.isEmpty {
                    EmptyStateView()
                }
                
                Spacer(minLength: 20)
            }
        }
        .background(Color(red: 242/255, green: 242/255, blue: 242/255))
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "bell.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No notifications")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.black)
            
            Text("You're all caught up!")
                .font(.system(size: 15))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 100)
    }
}

struct NewNotificationsSection: View {
    let notifications: [NotificationDto]
    @Binding var selectedNotification: NotificationDto?
    let onMarkAsRead: (Int) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "NEW")
                .padding(.top, 16)
                .padding(.bottom, 12)
            
            VStack(spacing: 0) {
                ForEach(Array(notifications.enumerated()), id: \.element.id) { index, notification in
                    Button(action: {
                        selectedNotification = notification
                        if !notification.isSeen {
                            onMarkAsRead(notification.id)
                        }
                    }) {
                        NotificationCard(
                            icon: notification.icon,
                            text: notification.message,
                            time: notification.timeAgo,
                            showDot: !notification.isSeen
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if index < notifications.count - 1 {
                        NotificationDivider()
                    }
                }
            }
            .background(Color.white)
        }
    }
}

struct EarlierNotificationsSection: View {
    let notifications: [NotificationDto]
    @Binding var selectedNotification: NotificationDto?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "EARLIER")
                .padding(.top, 24)
                .padding(.bottom, 12)
            
            VStack(spacing: 0) {
                ForEach(Array(notifications.enumerated()), id: \.element.id) { index, notification in
                    Button(action: {
                        selectedNotification = notification
                    }) {
                        NotificationCard(
                            icon: notification.icon,
                            text: notification.message,
                            time: notification.timeAgo,
                            showDot: false
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    if index < notifications.count - 1 {
                        NotificationDivider()
                    }
                }
            }
            .background(Color.white)
        }
    }
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 13, weight: .semibold))
            .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
            .padding(.horizontal, 16)
    }
}

struct NotificationCard: View {
    let icon: String
    let text: String
    let time: String
    let showDot: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            NotificationIcon(icon: icon)
            NotificationContent(text: text, time: time)
            Spacer(minLength: 8)
            if showDot {
                UnreadDot()
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
}

struct NotificationIcon: View {
    let icon: String
    
    var body: some View {
        Image(systemName: icon)
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(Color(red: 99/255, green: 99/255, blue: 102/255))
            .frame(width: 40, height: 40)
            .background(Color(red: 242/255, green: 242/255, blue: 247/255))
            .clipShape(Circle())
    }
}

struct NotificationContent: View {
    let text: String
    let time: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(time)
                .font(.system(size: 13))
                .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
        }
    }
}

struct UnreadDot: View {
    var body: some View {
        Circle()
            .fill(Color.black)
            .frame(width: 8, height: 8)
            .padding(.top, 6)
    }
}

struct NotificationDivider: View {
    var body: some View {
        Divider()
            .padding(.leading, 68)
            .background(Color(red: 229/255, green: 229/255, blue: 234/255))
    }
}

struct NotificationDetailSheet: View {
    let notification: NotificationDto
    @Binding var showSheet: Bool
    @Binding var navigateToEvent: Int?
    
    var body: some View {
        VStack(spacing: 0) {
            SheetHandle()
            
            if let eventTitle = notification.eventTitle {
                EventDetailsCard(
                    eventTitle: eventTitle,
                    notification: notification,
                    showSheet: $showSheet,
                    navigateToEvent: $navigateToEvent
                )
                ActionButtons(showSheet: $showSheet, notification: notification)
            } else {
                SimpleNotificationCard(notification: notification)
                Button(action: { showSheet = false }) {
                    Text("Close")
                        .font(.system(size: 17))
                        .foregroundColor(Color(red: 60/255, green: 60/255, blue: 67/255))
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 24)
            }
        }
        .background(.white)
        .presentationDetents([.height(400)])
        .presentationDragIndicator(.hidden)
    }
}

struct SimpleNotificationCard: View {
    let notification: NotificationDto
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(notification.title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)
            
            Text(notification.message)
                .font(.system(size: 15))
                .foregroundColor(Color(red: 60/255, green: 60/255, blue: 67/255))
            
            Text(notification.timeAgo)
                .font(.system(size: 13))
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
}

struct SheetHandle: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 2.5)
            .fill(Color(red: 199/255, green: 199/255, blue: 204/255))
            .frame(width: 36, height: 5)
            .padding(.top, 8)
            .padding(.bottom, 16)
    }
}

struct EventDetailsCard: View {
    let eventTitle: String
    let notification: NotificationDto
    @Binding var showSheet: Bool
    @Binding var navigateToEvent: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(eventTitle)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)
            
            Text(notification.message)
                .font(.system(size: 15))
                .foregroundColor(Color(red: 60/255, green: 60/255, blue: 67/255))
            
            Divider()
                .background(Color(red: 229/255, green: 229/255, blue: 234/255))
            
            EventActions(
                notification: notification,
                showSheet: $showSheet,
                navigateToEvent: $navigateToEvent
            )
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
}

struct EventActions: View {
    let notification: NotificationDto
    @Binding var showSheet: Bool
    @Binding var navigateToEvent: Int?
    
    var body: some View {
        VStack(spacing: 12) {
            if let eventId = notification.eventId {
                Button(action: {
                    showSheet = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        navigateToEvent = eventId
                    }
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.right.circle")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                        Text("View event details")
                            .font(.system(size: 15))
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 14)
                    .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                    .cornerRadius(8)
                }
            }
        }
    }
}

struct ActionButtons: View {
    @Binding var showSheet: Bool
    let notification: NotificationDto
    @State private var showCancelAlert = false
    
    var body: some View {
        VStack(spacing: 12) {
            if notification.type == "Registration", let eventId = notification.eventId {
                Button(action: {
                    showCancelAlert = true
                }) {
                    Text("Cancel Registration")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.red)
                        .cornerRadius(12)
                }
                .alert("Cancel Registration", isPresented: $showCancelAlert) {
                    Button("Cancel", role: .cancel) {}
                    Button("Confirm", role: .destructive) {
                        Task {
                            await cancelRegistration(eventId: eventId)
                        }
                    }
                } message: {
                    Text("Are you sure you want to cancel your registration for '\(notification.eventTitle ?? "this event")'?")
                }
            }
            
            Button(action: { showSheet = false }) {
                Text("Close")
                    .font(.system(size: 17))
                    .foregroundColor(Color(red: 60/255, green: 60/255, blue: 67/255))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
    
    private func cancelRegistration(eventId: Int) async {
        let eventService = AppConfig.makeEventService()
        do {
            try await eventService.unregisterFromEvent(eventId: eventId)
            showSheet = false
        } catch {
        }
    }
}
