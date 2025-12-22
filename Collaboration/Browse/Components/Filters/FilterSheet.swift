//
//  FilterSheet.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct FilterSheet: View {
    @Binding var isPresented: Bool
    @ObservedObject var viewModel: BrowseEventsVM
    let onApply: (EventFilters) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                AvailabilityFilter(showAvailableOnly: $viewModel.showAvailableOnly)
                LocationFilter(locationText: $viewModel.locationText)
                DateRangeFilter(range: $viewModel.dateRange)
                
                if viewModel.hasFiltersActive {
                    ActiveFiltersCount(count: viewModel.filtersActiveCount)
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    ClearFiltersButton(
                        isEnabled: viewModel.hasFiltersActive,
                        action: viewModel.clearFilters
                    )
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    ApplyFiltersButton(action: {
                        applyCurrentFilters()
                    })
                }
            }
        }
    }
    
    private func applyCurrentFilters() {
        let filters = viewModel.buildFilters()
        onApply(filters)
        isPresented = false
    }
}
