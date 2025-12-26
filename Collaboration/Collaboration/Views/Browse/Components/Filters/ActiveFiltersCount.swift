//
//  ActiveFiltersCount.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import SwiftUI

struct ActiveFiltersCount: View {
    let count: Int
    
    var body: some View {
        Section {
            HStack {
                Text("Active Filters")
                    .foregroundColor(.secondary)
                Spacer()
                Text("\(count)")
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
            }
        }
    }
}

