//
//  NotificationsViewModel.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/26/25.
//

import Foundation
import Combine

@MainActor
class NotificationsViewModel: ObservableObject {
    @Published var newNotifications: [NotificationDto] = []
    @Published var earlierNotifications: [NotificationDto] = []
    @Published var unreadCount: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var selectedTab: Int = 0
    
    private let eventService: EventServiceProtocol
    
    init(eventService: EventServiceProtocol = AppConfig.makeEventService()) {
        self.eventService = eventService
    }
    
    func loadNotifications() async {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await eventService.getNotifications()
            
            guard !Task.isCancelled else {
                isLoading = false
                return
            }
            
            self.newNotifications = filterByTab(response.new)
            self.earlierNotifications = filterByTab(response.earlier)
            self.unreadCount = response.totalUnseenCount
            
        } catch {
            errorMessage = "Failed to load notifications"
        }
        
        isLoading = false
    }
    
    func loadUnreadCount() async {
        do {
            let response = try await eventService.getUnreadCount()
            self.unreadCount = response.unreadCount
        } catch {
        }
    }
    
    func markAsRead(_ notificationId: Int) async {
        do {
            try await eventService.markAsRead(notificationId: notificationId)
            
            if let index = newNotifications.firstIndex(where: { $0.id == notificationId }) {
                newNotifications[index] = NotificationDto(
                    id: newNotifications[index].id,
                    title: newNotifications[index].title,
                    message: newNotifications[index].message,
                    type: newNotifications[index].type,
                    eventId: newNotifications[index].eventId,
                    eventTitle: newNotifications[index].eventTitle,
                    isSeen: true,
                    createdAt: newNotifications[index].createdAt
                )
            }
            
            await loadUnreadCount()
        } catch {
        }
    }
    
    func deleteNotification(_ notificationId: Int) async {
        do {
            try await eventService.deleteNotification(notificationId: notificationId)
            
            // Remove from local state
            newNotifications.removeAll { $0.id == notificationId }
            earlierNotifications.removeAll { $0.id == notificationId }
            
            await loadUnreadCount()
        } catch {
        }
    }
    
    private func filterByTab(_ notifications: [NotificationDto]) -> [NotificationDto] {
        switch selectedTab {
        case 0:
            return notifications
        case 1:
            return notifications.filter { $0.type == "Registration" || $0.type == "Unregistration" }
        case 2:
            return notifications.filter { $0.type == "Reminder" }
        case 3:
            return notifications.filter { $0.type == "Update" || $0.type == "Welcome" }
        default:
            return notifications
        }
    }
    
    func changeTab(to tab: Int) {
        selectedTab = tab
        Task {
            await loadNotifications()
        }
    }
}
