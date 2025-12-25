//
//  BrowseEventsView.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import SwiftUI

struct BrowseEventsScreen: View {
    @StateObject private var viewModel = BrowseEventsVM()
    @State private var selectedCategoryForDetail: CategoryDto?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                BrowseHeader()
                
                SearchFilterRow(
                    searchText: $viewModel.searchQuery,
                    showingFilters: $viewModel.showingFilters
                )
                
                CategoryFilterRow(
                    categories: viewModel.categories,
                    activeCategory: $viewModel.activeCategory,
                    onSelect: viewModel.selectCategory,
                    onLongPress: { (category: CategoryDto) in
                        selectedCategoryForDetail = category
                    }
                )
                
                ContentStateView(
                    isLoading: viewModel.isLoading,
                    events: viewModel.events,
                    error: viewModel.errorMessage,
                    onRetry: {
                        Task {
                            await viewModel.reload()
                        }
                    }
                )
            }
            .navigationBarHidden(true)
        }
        .task {
            await viewModel.loadInitialData()
        }
        .onChange(of: viewModel.searchQuery) { oldValue, newValue in
            viewModel.updateSearch(newValue)
        }
        .sheet(isPresented: $viewModel.showingFilters) {
            FilterSheet(
                isPresented: $viewModel.showingFilters,
                viewModel: viewModel,
                onApply: viewModel.applyFilters
            )
        }
        .sheet(item: $selectedCategoryForDetail) { (category: CategoryDto) in
            CategoryDetailScreen(category: category)
        }
    }
}
