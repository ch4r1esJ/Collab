//
//  LocationFilter.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct LocationFilter: View {
    @Binding var locationText: String
    
    var body: some View {
        Section("Location") {
            TextField("Enter location", text: $locationText)
        }
    }
}
