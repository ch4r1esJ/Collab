//
//  RegistrationStats.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import SwiftUI

struct RegistrationStats: View {
    let event: EventListDto
    
    var body: some View {
        HStack(spacing: 16) {
            HStack(spacing: 4) {
                Image(systemName: "person.2")
                    .font(.caption)
                Text("\(event.currentCapacity) registered")
                    .font(.caption)
            }
            
            HStack(spacing: 4) {
                Image(systemName: event.availableSlots == 0 ? "person.fill.xmark" : "person.fill.checkmark")
                    .font(.caption)
                Text(event.availableSlots == 0 ? "0 spots left" : "\(event.availableSlots) spots left")
                    .font(.caption)
            }
        }
        .foregroundColor(.secondary)
    }
}
