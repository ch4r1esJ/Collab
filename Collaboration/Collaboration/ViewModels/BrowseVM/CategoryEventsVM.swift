//
//  CategoryEventsVM.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import Foundation
import SwiftUI
import Combine

@MainActor
class CategoryEventsVM: ObservableObject {
    @Published var events: [EventListDto] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let apiService = MockAPIService.shared
    
    func fetchEvents(categoryId: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let results = try await apiService.getEvents(eventTypeId: categoryId)
            events = results
        } catch {
            if let apiError = error as? APIError {
                errorMessage = apiError.errorMessage
            } else {
                errorMessage = error.localizedDescription
            }
        }
        
        isLoading = false
    }
}
