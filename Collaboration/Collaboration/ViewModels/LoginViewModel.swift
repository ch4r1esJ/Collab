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
    
    private let rememberMeKey = "rememberMe"
    private let savedEmailKey = "savedEmail"
    
    init(authService: AuthServiceProtocol = AppConfig.makeAuthService()) {
        self.authService = authService
        loadSavedEmail()
    }
    
    var isFormValid: Bool {
        !email.isEmpty &&
        Validator.isValidEmail(email) &&
        !password.isEmpty &&
        password.count >= AppConstants.Validation.minPasswordLength
    }
    
    func loadSavedEmail() {
        let isRemembered = UserDefaults.standard.bool(forKey: rememberMeKey)
        
        if isRemembered {
            if let savedEmail = UserDefaults.standard.string(forKey: savedEmailKey) {
                self.email = savedEmail
                self.rememberMe = true
            }
        }
    }
    
    private func handleRememberMe() {
        if rememberMe {
            UserDefaults.standard.set(true, forKey: rememberMeKey)
            UserDefaults.standard.set(email, forKey: savedEmailKey)
        } else {
            UserDefaults.standard.removeObject(forKey: rememberMeKey)
            UserDefaults.standard.removeObject(forKey: savedEmailKey)
        }
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
            
            if response.isAdmin {
                tokenManager.clearToken()
                errorMessage = "Admin accounts cannot login through the mobile app. Please use the admin web portal."
                isLoading = false
                return
            }
            
            handleRememberMe()
            
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
