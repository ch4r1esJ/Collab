//
//  CategoryDetailScreen.swift
//  Collaboration
//
//  Created by Rize on 22.12.25.
//

import SwiftUI

struct CategoryDetailScreen: View {
    let category: CategoryDto
    
    @StateObject private var viewModel = CategoryEventsVM()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CategoryInfoHeader(category: category)
                
                ContentStateView(
                    isLoading: viewModel.isLoading,
                    events: viewModel.events,
                    error: viewModel.errorMessage,
                    onRetry: {
                        Task {
                            await viewModel.fetchEvents(categoryId: category.id)
                        }
                    }
                )
            }
            .navigationTitle(category.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    }
                }
            }
        }
        .task {
            await viewModel.fetchEvents(categoryId: category.id)
        }
    }
}
