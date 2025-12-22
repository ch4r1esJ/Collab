//
//  ApplyFiltersButton.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct ApplyFiltersButton: View {
    let action: () -> Void
    
    var body: some View {
        Button("Apply", action: action)
            .fontWeight(.semibold)
    }
}

#Preview {
    ApplyFiltersButton(action: {})
}
