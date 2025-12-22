//
//  EventsCard.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI

struct EventCard: View {
    let event: Event
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            EventDateView(month: event.month, day: event.day)
            .frame(width: 50)
            
            VStack(alignment: .leading, spacing: 12) {
                EventTitleView(title: event.title, isWaitlisted: event.isWaitlisted)
                
                
                TimeView(time: event.time, location: event.location)
                .font(.system(size: 14, weight: .light))
                
                Text(event.description)
                    .font(.system(size: 15, weight: .light))
                    .lineLimit(2)
                
                HStack {
                    Label("\(event.registeredCount) registered • \(event.spotsLeft)", systemImage: "person.2")
                        .font(.system(size: 13, weight: .light))
                        
                    Spacer()
                    
                    Button(action: {}) {
                        HStack(spacing: 4) {
                            Text("View Details")
                            Image(systemName: "arrow.right")
                        }
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.black)
                    }
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
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
    var isWaitlisted: Bool
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 18, weight: .medium))
            
            if isWaitlisted {
                Text("Waitlisted")
                    .font(.system(size: 12, weight: .medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
            }
        }
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

#Preview {
    EventCard(event: Event.mockEvent)
}
