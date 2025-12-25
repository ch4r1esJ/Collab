//
//  NotificationsView.swift
//  davigale
//
//  Created by Rize on 25.12.25.
//

import SwiftUI

struct NotificationsView: View {
    @State private var showDetailSheet = false
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            NavigationHeader()
            Divider().background(Color(red: 229/255, green: 229/255, blue: 234/255))
            TabBar(selectedTab: $selectedTab)
            Divider().background(Color(red: 229/255, green: 229/255, blue: 234/255))
            NotificationsList(showDetailSheet: $showDetailSheet)
        }
        .background(Color(red: 242/255, green: 242/255, blue: 242/255))
        .sheet(isPresented: $showDetailSheet) {
            NotificationDetailSheet(showSheet: $showDetailSheet)
        }
    }
}

struct NavigationHeader: View {
    var body: some View {
        HStack(spacing: 0) {
            Button(action: {}) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.black)
                    .frame(width: 44, height: 44)
            }
            
            Spacer()
            
            Text("Notifications")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)
            
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
    
    var body: some View {
        HStack(spacing: 0) {
            TabButton(title: "All", isSelected: selectedTab == 0, action: { selectedTab = 0 })
            TabButton(title: "Registrations", isSelected: selectedTab == 1, action: { selectedTab = 1 })
            TabButton(title: "Reminders", isSelected: selectedTab == 2, action: { selectedTab = 2 })
            TabButton(title: "Updates", isSelected: selectedTab == 3, action: { selectedTab = 3 })
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
    @Binding var showDetailSheet: Bool
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                NewNotificationsSection(showDetailSheet: $showDetailSheet)
                EarlierNotificationsSection()
                Spacer(minLength: 20)
            }
        }
        .background(Color(red: 242/255, green: 242/255, blue: 242/255))
    }
}

struct NewNotificationsSection: View {
    @Binding var showDetailSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "NEW")
                .padding(.top, 16)
                .padding(.bottom, 12)
            
            VStack(spacing: 0) {
                Button(action: { showDetailSheet = true }) {
                    NotificationCard(
                        icon: "calendar",
                        text: "Registration Confirmed: You are now registered for the 'Leadership Workshop: Effective Communication'.",
                        time: "15 minutes ago",
                        showDot: true
                    )
                }
                .buttonStyle(PlainButtonStyle())
                
                NotificationDivider()
                
                NotificationCard(
                    icon: "bell.fill",
                    text: "Event Reminder: 'Annual Team Building Summit' starts in 24 hours. Don't forget to join!",
                    time: "1 hour ago",
                    showDot: true
                )
            }
            .background(Color.white)
        }
    }
}

struct EarlierNotificationsSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionHeader(title: "EARLIER")
                .padding(.top, 24)
                .padding(.bottom, 12)
            
            VStack(spacing: 0) {
                NotificationCard(
                    icon: "info.circle.fill",
                    text: "Event Update: The location for 'Happy Friday: Game Night' has been changed to the Recreation Lounge.",
                    time: "Yesterday",
                    showDot: false
                )
                
                NotificationDivider()
                
                NotificationCard(
                    icon: "person.2.fill",
                    text: "Waitlist Update: A spot has opened up for 'Tech Talk: AI in Business Operations'. You have been automatically registered.",
                    time: "2 days ago",
                    showDot: false
                )
                
                NotificationDivider()
                
                NotificationCard(
                    icon: "calendar",
                    text: "Cancellation: Your registration for the 'Wellness Wednesday Yoga' has been successfully cancelled.",
                    time: "Dec 12, 2025",
                    showDot: false
                )
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
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            SheetHandle()
            EventDetailsCard()
            ActionButtons(showSheet: $showSheet)
        }
        .background(.white)
        .presentationDetents([.height(400)])
        .presentationDragIndicator(.hidden)
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
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Tech Talk: AI in Business")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.black)
            
            EventInfo()
            
            Divider()
                .background(Color(red: 229/255, green: 229/255, blue: 234/255))
            
            EventActions()
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
}

struct EventInfo: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "calendar")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
                    .frame(width: 20)
                Text("Jan 26, 2025, 11:00 AM - 12:30 PM")
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 60/255, green: 60/255, blue: 67/255))
            }
            
            HStack(spacing: 10) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 16))
                    .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
                    .frame(width: 20)
                Text("Virtual Meeting")
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 60/255, green: 60/255, blue: 67/255))
            }
        }
    }
}

struct EventActions: View {
    var body: some View {
        VStack(spacing: 12) {
            Button(action: {}) {
                HStack(spacing: 12) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                    Text("Send a question about the event")
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(red: 242/255, green: 242/255, blue: 247/255))
                .cornerRadius(8)
            }
            
            Button(action: {}) {
                HStack(spacing: 12) {
                    Image(systemName: "calendar.badge.plus")
                        .font(.system(size: 20))
                        .foregroundColor(.black)
                    Text("Add to my calendar")
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

struct ActionButtons: View {
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Button(action: {}) {
                Text("Cancel Registration")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.black)
                    .cornerRadius(12)
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
}
