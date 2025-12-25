//
//  EventSearchField.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import SwiftUI

struct EventSearchField: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search events...", text: $text)
                .textFieldStyle(.plain)
        }
        .padding(12)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    EventSearchField(text: .constant(""))
}
