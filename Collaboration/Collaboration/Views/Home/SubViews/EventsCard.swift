//
//  EventsCard.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI

struct EventCard: View {
    @EnvironmentObject var coordinator: AppCoordinator
    let event: EventListDto
    var isWaitlisted: Bool = false
    
    var body: some View {
        Button(action: {
            coordinator.navigate(to: .eventDetails(event.id))
        }) {
            cardContent
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var cardContent: some View {
        HStack(alignment: .top, spacing: 16) {
            EventDateView(month: formattedMonth, day: formattedDay)
                .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(event.title)
                    .font(.system(size: 18, weight: .semibold))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.system(size: 14))
                    Text(event.timeRange)
                        .font(.system(size: 14))
                }
                .foregroundColor(.secondary)
                
                HStack(alignment: .top, spacing: 4) {
                    Image(systemName: "mappin.circle.fill")
                        .font(.system(size: 14))
                    Text(event.location)
                        .font(.system(size: 14))
                        .lineLimit(1)
                }
                .foregroundColor(.secondary)
                
                if !event.description.isEmpty {
                    Text(event.description)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack {
                    HStack(spacing: 4) {
                        Image(systemName: "person.2")
                            .font(.system(size: 13))
                        Text("\(event.currentCapacity) registered • \(spotsLeftText)")
                            .font(.system(size: 13))
                    }
                    .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("View Details")
                        Image(systemName: "arrow.right")
                    }
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.blue)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
        .overlay(alignment: .topTrailing) {
            if isWaitlisted {
                Text("Waitlisted")
                    .font(.system(size: 11, weight: .bold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())
                    .padding([.top, .trailing], 12)
            }
        }
    }
    
    private var spotsLeftText: String {
        if event.availableSlots == 0 {
            return "Full"
        } else {
            return "\(event.availableSlots) spot\(event.availableSlots == 1 ? "" : "s") left"
        }
    }
    
    private var eventDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.date(from: event.startDateTime) ?? Date()
    }
    
    private var formattedMonth: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return formatter.string(from: eventDate).uppercased()
    }
    
    private var formattedDay: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter.string(from: eventDate)
    }
    
    private var formattedTime: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: eventDate)
    }
}

struct EventDateView: View {
    let month: String
    let day: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(month)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary)
            Text(day)
                .font(.system(size: 28, weight: .bold))
        }
    }
}
