//
//  SignInView.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI

struct SignInView: View {
    @StateObject private var viewModel = LoginViewModel()
    @EnvironmentObject var coordinator: AppCoordinator
    @State private var showPassword = false
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 40) {
                    headerSection
                    formSection
                }
                .padding(.top, 24)
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
            .disabled(viewModel.isLoading)
            
            if viewModel.isLoading {
                loadingOverlay
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") { viewModel.errorMessage = nil }
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .alert("Success", isPresented: .constant(viewModel.successMessage != nil)) {
            Button("OK") {
                viewModel.successMessage = nil
            }
        } message: {
            Text(viewModel.successMessage ?? "")
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Sign In")
                .font(.system(size: 32, weight: .semibold))
                .foregroundColor(Color(red: 0.1, green: 0.1, blue: 0.1))
            
            Text("Enter your credentials to access your account")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
                .multilineTextAlignment(.center)
        }
    }
    
    private var formSection: some View {
        VStack(spacing: 20) {
            emailField
            passwordField
            rememberMeRow
            signInButton
            signUpLink
        }
    }
    
    private var emailField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            
            TextField("Enter your email", text: $viewModel.email)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(red: 0.97, green: 0.97, blue: 0.97))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
        }
    }
    
    private var passwordField: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Password")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            
            HStack {
                if showPassword {
                    TextField("Enter your password", text: $viewModel.password)
                } else {
                    SecureField("Enter your password", text: $viewModel.password)
                }
                
                Button(action: { showPassword.toggle() }) {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
    
    private var rememberMeRow: some View {
        HStack {
            Button(action: { viewModel.rememberMe.toggle() }) {
                HStack(spacing: 8) {
                    Image(systemName: viewModel.rememberMe ? "checkmark.square" : "square")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                    Text("Remember me")
                        .font(.system(size: 14))
                        .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
                }
            }
            
            Spacer()
            
            NavigationLink {
                ForgotPasswordView(onPasswordReset: { email, password in
                    viewModel.email = email
                    viewModel.password = password
                    viewModel.successMessage = "Password reset successful! Your temporary password is: Password123"
                })
            } label: {
                Text("Forgot password?")
                    .font(.system(size: 14))
                    .foregroundColor(.black)
            }
        }
    }
    
    private var signInButton: some View {
        Button(action: {
            Task {
                await viewModel.login(coordinator: coordinator)
            }
        }) {
            Text("Sign In")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(viewModel.isFormValid ? Color("button") : Color.gray)
                .cornerRadius(8)
        }
        .disabled(!viewModel.isFormValid || viewModel.isLoading)
    }
    
    private var signUpLink: some View {
        HStack(spacing: 4) {
            Text("Don't have an account?")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.5, green: 0.5, blue: 0.5))
            NavigationLink {
                SignUpView()
            } label: {
                Text("Sign up")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.2, green: 0.2, blue: 0.2))
            }
        }
    }
    
    private var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            ProgressView()
                .scaleEffect(1.5)
                .tint(.white)
        }
    }
}

#Preview {
    NavigationStack {
        SignInView()
            .environmentObject(AppCoordinator())
    }
}
