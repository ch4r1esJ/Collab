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
    
    private let authService: AuthServiceProtocol
    private let tokenManager = TokenManager.shared
    
    init(authService: AuthServiceProtocol = AppConfig.makeAuthService()) {
        self.authService = authService
    }
    
    var isFormValid: Bool {
        !email.isEmpty &&
        Validator.isValidEmail(email) &&
        !password.isEmpty &&
        password.count >= AppConstants.Validation.minPasswordLength
    }
    
    func login(coordinator: AppCoordinator) async {
        guard isFormValid else {
            errorMessage = Strings.Error.fillAllFields
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await authService.login(email: email, password: password)
            
            let user = UserProfileDto(
                id: response.userId,
                email: response.email,
                fullName: response.fullName,
                department: response.department,
                isAdmin: response.isAdmin
            )
            
            coordinator.login(
                token: response.token,
                user: user,
                expiresAt: response.expiresAt
            )
            
            successMessage = Strings.Success.welcome(name: response.fullName)
            
        } catch let error as APIError {
            errorMessage = error.errorMessage
        } catch {
            errorMessage = "An unexpected error occurred"
        }
        
        isLoading = false
    }
    
    func forgotPassword() async {
        guard Validator.isValidEmail(email) else {
            errorMessage = Strings.Error.invalidEmail
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.sendPasswordResetLink(email: email)
            successMessage = String(format: Strings.Success.passwordResetSent, email)
        } catch let error as APIError {
            errorMessage = error.errorMessage
        } catch {
            errorMessage = "Failed to send reset link"
        }
        
        isLoading = false
    }
}
