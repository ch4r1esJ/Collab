//
//  BrowseHeader.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import SwiftUI

struct BrowseHeader: View {
    var body: some View {
        HStack {
            Text("Browse Events")
                .font(.title2)
            
            Spacer()
            
            Button(action: {}) {
                Image("BrowseEventsIcon")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
    }
}
