//
//  EmptyStateView.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import SwiftUI

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No Events Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("There are no upcoming events at the moment. Check back later!")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
