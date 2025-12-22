//
//  RegistrationStats.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct RegistrationStats: View {
    let event: EventListDto
    
    private var remainingSpots: Int {
        SpotsCalculator.availableSpots(capacity: event.capacity, confirmed: event.confirmedCount)
    }
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 4) {
                Image(systemName: "person.2")
                    .font(.caption)
                Text("\(event.confirmedCount) registered")
                    .font(.caption)
            }
            
            HStack(spacing: 4) {
                Image(systemName: event.isFull ? "person.fill.xmark" : "person.fill.checkmark")
                    .font(.caption)
                Text(event.isFull ? "0 spots left" : "\(remainingSpots) spots left")
                    .font(.caption)
            }
        }
        .foregroundColor(.secondary)
    }
}
