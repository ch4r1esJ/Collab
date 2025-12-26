//
//  SignUpView.swift
//  medzineba2
//
//  Created by Rize on 20.12.25.
//

import SwiftUI
import Combine

struct SignUpView: View {
    @StateObject private var viewModel = RegistrationViewModel()
    @EnvironmentObject var coordinator: AppCoordinator
    @Environment(\.dismiss) var dismiss
    @State private var showPassword = false
    @State private var showConfirmPassword = false

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 0) {
                    headerSection
                    formSection
                }
            }
            .background(Color(.systemGray6))
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
        .alert("Success", isPresented: Binding(
            get: { viewModel.successMessage != nil },
            set: { _ in viewModel.successMessage = nil }
        )) {
            Button("OK") {
                if viewModel.registrationSuccessful {
                    dismiss()
                }
                viewModel.successMessage = nil
            }
        } message: {
            Text(viewModel.successMessage ?? "")
        }
        .onReceive(timer) { _ in
            if viewModel.timeRemaining > 0 && viewModel.isOTPSent {
                viewModel.timeRemaining -= 1
            }
        }.navigationBarBackButtonHidden(true)
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Create Account")
                .font(.system(size: 24, weight: .bold))
            Text("Enter your details to get started.")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .padding(.top, 40)
        .padding(.bottom, 32)
    }
    
    private var formSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            RegistrationNameFields(
                firstName: $viewModel.firstName,
                lastName: $viewModel.lastName
            )
            
            RegistrationEmailField(email: $viewModel.email)
            
            RegistrationPhoneField(phoneNumber: $viewModel.phoneNumber, onSendOTP: { Task { await viewModel.sendOTP() } })
            
            
            if viewModel.isOTPSent {
                otpSection
            }
            
            RegistrationDepartmentPicker(
                departments: viewModel.departments,
                selectedDepartment: $viewModel.selectedDepartment
            )
                        
            RegistrationPasswordField(
                password: $viewModel.password,
                showPassword: $showPassword
            )
            
            RegistrationConfirmPasswordField(
                confirmPassword: $viewModel.confirmPassword,
                showConfirmPassword: $showConfirmPassword
            )
            
            passwordMatchIndicator
            termsCheckbox
            createAccountButton
            signInLink
        }
        .padding(.horizontal, 32)
        .padding(.bottom, 40)
    }
    
    private var otpSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Text("Enter OTP Code")
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
            }
            
            HStack(spacing: 8) {
                ForEach(0..<6, id: \.self) { index in
                    TextField("", text: $viewModel.otpCode[index])
                        .frame(width: 48, height: 56)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .medium))
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .keyboardType(.numberPad)
                        .onChange(of: viewModel.otpCode[index]) { oldValue, newValue in
                            if newValue.count > 1 {
                                viewModel.otpCode[index] = String(newValue.prefix(1))
                            }
                        }
                }
            }
            .onChange(of: viewModel.otpCodeString) { oldValue, newValue in
                if newValue.count == AppConstants.OTP.codeLength && !viewModel.isOTPVerified {
                    Task { await viewModel.verifyOTP() }
                }
            }
            
            otpTimerSection
            
            if viewModel.isOTPVerified {
                verificationSuccessIndicator
            }
        }
    }
    
    private var otpTimerSection: some View {
        HStack {
            HStack(spacing: 4) {
                Image(systemName: "clock")
                    .font(.system(size: 11))
                    .foregroundColor(viewModel.isOTPExpired ? .red : .gray)
                
                if viewModel.isOTPExpired {
                    Text("Code expired")
                        .font(.system(size: 13))
                        .foregroundColor(.red)
                } else {
                    Text("Code expires in \(formattedTime)")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            Button(action: {
                Task {
                    await viewModel.resendOTP()
                }
            }) {
                Text("Resend Code")
                    .font(.system(size: 13))
                    .foregroundColor(viewModel.isOTPExpired ? .blue : .gray)
            }
            .disabled(!viewModel.isOTPExpired)
        }
    }
    
    private var formattedTime: String {
        let minutes = viewModel.timeRemaining / 60
        let seconds = viewModel.timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private var verificationSuccessIndicator: some View {
        HStack(spacing: 4) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 14))
                .foregroundColor(.green)
            Text("Phone number verified")
                .font(.system(size: 13))
                .foregroundColor(.green)
        }
    }
    
    private var passwordMatchIndicator: some View {
        Group {
            if !viewModel.confirmPassword.isEmpty {
                HStack(spacing: 4) {
                    Image(systemName: viewModel.password == viewModel.confirmPassword ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(viewModel.password == viewModel.confirmPassword ? .green : .red)
                    Text(viewModel.password == viewModel.confirmPassword ? "Passwords match" : "Passwords do not match")
                        .font(.system(size: 12))
                        .foregroundColor(viewModel.password == viewModel.confirmPassword ? .green : .red)
                }
            }
        }
    }
    
    private var termsCheckbox: some View {
        HStack(alignment: .top, spacing: 12) {
            Button(action: { viewModel.agreedToTerms.toggle() }) {
                Image(systemName: viewModel.agreedToTerms ? "checkmark.square.fill" : "square")
                    .font(.system(size: 20))
                    .foregroundColor(viewModel.agreedToTerms ? .blue : .gray)
            }
            
            Text("I agree to the Terms of Service and Privacy Policy")
                .font(.system(size: 14))
                .foregroundColor(.primary)
        }
        .padding(.top, 8)
    }
    
    private var createAccountButton: some View {
        Button(action: {
            Task {
                await viewModel.register()
            }
        }) {
            if viewModel.isLoading {
                ProgressView()
                    .tint(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            } else {
                Text("Create Account")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
            }
        }
        .background(viewModel.isFormValid ? Color("button") : Color.gray)
        .cornerRadius(8)
        .disabled(!viewModel.isFormValid || viewModel.isLoading)
        .padding(.top, 8)
    }
    
    private var signInLink: some View {
        HStack(spacing: 4) {
            Text("Already have an account?")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            Button("Sign In") {
                dismiss()
            }
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
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
