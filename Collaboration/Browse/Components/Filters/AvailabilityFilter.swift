//
//  AvailabilityFilter.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct AvailabilityFilter: View {
    @Binding var showAvailableOnly: Bool
    
    var body: some View {
        Section {
            Toggle("Only show available events", isOn: $showAvailableOnly)
        }
    }
}

#Preview {
    Form {
        AvailabilityFilter(showAvailableOnly: .constant(false))
    }
}
