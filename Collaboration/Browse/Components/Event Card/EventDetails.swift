//
//  EventDetails.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct EventDetails: View {
    let event: EventListDto
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            CategoryStatusRow(
                categoryName: event.eventTypeName,
                statusInfo: EventStatusProvider.statusInfo(
                    isFull: event.isFull,
                    confirmedCount: event.confirmedCount,
                    capacity: event.capacity
                )
            )
            
            TitleLabel(text: event.title)
            TimeLabel(startTime: event.startDateTime)
            LocationLabel(place: event.location)
            RegistrationStats(event: event)
        }
    }
}
