//
//  LoginViewModel.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class LoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var rememberMe = false
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isLoggedIn = false
    
    private var authToken: String?
    private var currentUser: User?
    
    var isFormValid: Bool {
        !email.isEmpty &&
        Validator.isValidEmail(email) &&
        !password.isEmpty &&
        password.count >= AppConstants.Validation.minPasswordLength
    }
    
    func login() async {
        guard isFormValid else {
            errorMessage = Strings.Error.fillAllFields
            return
        }
        
        isLoading = true
        
        try? await Task.sleep(nanoseconds: AppConstants.Animation.loadingDelay)
        
        if email == "test@example.com" && password == "Password123" {
            
            let mockUser = User(
                id: "0",
                email: "watever@gmail.com",
                fullName: "John Doe",
                role: "User"
            )
            
            authToken = "mock_token_\(UUID().uuidString)"
            currentUser = mockUser
            
            successMessage = Strings.Success.welcome(name: mockUser.fullName)
            isLoggedIn = true
        } else {
            errorMessage = Strings.Error.invalidCredentials
        }
        
        isLoading = false
    }
    
    func forgotPassword() async {
        guard Validator.isValidEmail(email) else {
            errorMessage = Strings.Error.invalidEmail
            return
        }
        
        isLoading = true
        
        try? await Task.sleep(nanoseconds: AppConstants.Animation.loadingDelay)
        
        successMessage = String(format: Strings.Success.passwordResetSent, email)
        
        isLoading = false
    }
    
    func logout() {
        authToken = nil
        currentUser = nil
        isLoggedIn = false
        email = ""
        password = ""
        rememberMe = false
        errorMessage = nil
        successMessage = nil
    }
    
    func getAuthToken() -> String? {
        return authToken
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
}
