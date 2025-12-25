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
            
            VStack(alignment: .leading, spacing: 12) {
                EventTitleView(title: event.title)
                
                TimeView(time: formattedTime, location: event.location)
                    .font(.system(size: 14, weight: .light))
                
                if !event.description.isEmpty {
                    Text(event.description)
                        .font(.system(size: 15, weight: .light))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                HStack {
                    Label {
                        Text("\(event.currentCapacity) registered • \(spotsLeftText)")
                    } icon: {
                        Image(systemName: "person.2")
                            .foregroundStyle(.secondary)
                    }
                    .font(.system(size: 13, weight: .light))
                    
                    Spacer()
                    
                    HStack(spacing: 4) {
                        Text("View Details")
                        Image(systemName: "arrow.right")
                    }
                    .font(.system(size: 14, weight: .regular))
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
        return formatter.string(from: eventDate)
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
            Text(month.uppercased())
                .font(.system(size: 14, weight: .light))
            Text(day)
                .font(.system(size: 28, weight: .medium))
        }
    }
}

struct EventTitleView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 18, weight: .medium))
            .padding(.trailing, 70)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TimeView: View {
    var time: String
    var location: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 4) {
                Image(systemName: "clock")
                Text(time)
            }
            
            HStack(alignment: .top, spacing: 4) {
                Image("map")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 17, height: 17)
                Text(location)
                    .fixedSize(horizontal: false, vertical: true)
                    .multilineTextAlignment(.leading)
            }
        }
    }
}
