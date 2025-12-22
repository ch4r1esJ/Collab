//
//  SearchFilterRow.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct SearchFilterRow: View {
    @Binding var searchText: String
    @Binding var showingFilters: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            EventSearchField(text: $searchText)
            FilterToggleButton(isShowing: $showingFilters)
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 16)
    }
}

#Preview {
    SearchFilterRow(searchText: .constant(""), showingFilters: .constant(false))
}
