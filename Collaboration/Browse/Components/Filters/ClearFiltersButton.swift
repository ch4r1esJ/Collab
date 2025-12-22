//
//  ClearFiltersButton.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct ClearFiltersButton: View {
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button("Reset", action: action)
            .disabled(!isEnabled)
    }
}

#Preview {
    ClearFiltersButton(isEnabled: true, action: {})
}
