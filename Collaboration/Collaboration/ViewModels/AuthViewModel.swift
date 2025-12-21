//
//  AuthViewModel.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import Foundation
import Combine

@MainActor
class AuthViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let authService: AuthServiceProtocol
    
    init(authService: AuthServiceProtocol = MockAuthService()) {
        self.authService = authService
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        isAuthenticated = TokenManager.shared.isLoggedIn()
//        currentUser = TokenManager.shared.getUser()
    }
    
    // MARK: - Login
    func login(email: String, password: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await authService.login(email: email, password: password)
            
            TokenManager.shared.saveToken(response.token)
            TokenManager.shared.saveUserId(response.userId)
            
            let profile = User(
                id: response.userId,
                email: email,
                fullName: response.fullName,
                role: response.role
            )
//            TokenManager.shared.saveUser(profile)
            
            currentUser = profile
            isAuthenticated = true
            
        } catch NetworkError.invalidEmail {
            errorMessage = "Please enter a valid email"
        } catch NetworkError.invalidPassword {
            errorMessage = "Password must be at least 6 characters"
        } catch NetworkError.serverError(401) {
            errorMessage = "Invalid email or password"
        } catch {
            errorMessage = "Something went wrong. Please try again."
        }
        
        isLoading = false
    }
    
    // MARK: - Register
    func register(email: String, password: String, fullName: String) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let response = try await authService.register(
                email: email,
                password: password,
                fullName: fullName
            )
            
            TokenManager.shared.saveToken(response.token)
            TokenManager.shared.saveUserId(response.userId)
            
            let profile = User(
                id: response.userId,
                email: email,
                fullName: response.fullName,
                role: response.role
            )
//            TokenManager.shared.saveUser(profile)
            
            currentUser = profile
            isAuthenticated = true
            
        } catch NetworkError.invalidEmail {
            errorMessage = "Please enter a valid email"
        } catch NetworkError.invalidPassword {
            errorMessage = "Password must be at least 6 characters"
        } catch {
            errorMessage = "Registration failed. Please try again."
        }   
        
        isLoading = false
    }
    
    func logout() {
//        TokenManager.shared.deleteAll()
        currentUser = nil
        isAuthenticated = false
    }
}
