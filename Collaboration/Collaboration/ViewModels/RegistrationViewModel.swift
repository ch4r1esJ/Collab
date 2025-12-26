//
//  RegistrationViewModel.swift
//  medzineba2
//
//  Created by Rize on 20.12.25.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class RegistrationViewModel: ObservableObject {
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var phoneNumber = ""
    @Published var otpCode = ["", "", "", "", "", ""]
    @Published var selectedDepartment: DepartmentDto?
    @Published var departments: [DepartmentDto] = []
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var agreedToTerms = false
    
    @Published var isOTPSent = false
    @Published var isOTPVerified = false
    @Published var timeRemaining = 60
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isRegistered = false
    
    @Published var phoneNumberError: String?
    @Published var showPhoneError = false
    @Published var registrationSuccessful = false
    
    private var storedOTP: String?
    private var otpPhoneNumber: String?
    
    private let authService: AuthServiceProtocol
    private let tokenManager = TokenManager.shared
    
    init(authService: AuthServiceProtocol = AppConfig.makeAuthService()) {
        self.authService = authService
        
        Task {
            await loadDepartments()
        }
    }
    
    var otpCodeString: String {
        otpCode.joined()
    }
    
    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
    
    var isOTPExpired: Bool {
        timeRemaining == 0 && isOTPSent
    }
    
    var isFormValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        Validator.isValidEmail(email) &&
        Validator.isValidPhone(phoneNumber) &&
        isOTPVerified &&
        selectedDepartment != nil &&
        Validator.isValidPassword(password).isValid &&
        password == confirmPassword &&
        agreedToTerms
    }
    
    func loadDepartments() async {
        do {
            departments = try await authService.getDepartments()
            selectedDepartment = departments.first
        } catch {
            errorMessage = "Failed to load departments"
        }
    }
    
    func handlePhoneNumberChange(_ newValue: String) {
        let allowedChars = "0123456789+- ()"
        var hasInvalidChar = false
        
        for char in newValue {
            if !allowedChars.contains(char) {
                hasInvalidChar = true
                break
            }
        }
        
        if hasInvalidChar {
            phoneNumber = newValue.filter { allowedChars.contains($0) }
            phoneNumberError = Strings.Error.onlyNumbersAllowed
            showPhoneError = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.showPhoneError = false
            }
        }
    }
    
    func sendOTP() async {
        if phoneNumber.isEmpty {
            errorMessage = Strings.Error.phoneNumberRequired
            return
        }
        
        if !Validator.isValidPhone(phoneNumber) {
            errorMessage = Strings.Error.invalidPhoneNumber
            return
        }
        
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        isOTPSent = true
        otpPhoneNumber = phoneNumber
        timeRemaining = 60
        successMessage = "OTP code sent to \(phoneNumber)."
        
        isLoading = false
    }
    
    func verifyOTP() async {
        if otpCodeString.count != AppConstants.OTP.codeLength {
            errorMessage = Strings.Error.otpIncomplete
            return
        }
        
        if phoneNumber != otpPhoneNumber {
            errorMessage = Strings.Error.phoneNumberMismatch
            otpCode = ["", "", "", "", "", ""]
            return
        }
        
        if isOTPExpired {
            errorMessage = "OTP code has expired. Please request a new code."
            otpCode = ["", "", "", "", "", ""]
            return
        }
        
        isLoading = true
        
        do {
            let isValid = try await authService.verifyOTP(code: otpCodeString)
            
            if isValid {
                isOTPVerified = true
                successMessage = "Phone verified successfully!"
            } else {
                errorMessage = "Invalid OTP code"
                otpCode = ["", "", "", "", "", ""]
            }
        } catch {
            errorMessage = "OTP verification failed"
            otpCode = ["", "", "", "", "", ""]
        }
        
        isLoading = false
    }
    
    func resendOTP() async {
        if phoneNumber.isEmpty {
            errorMessage = Strings.Error.phoneNotFound
            return
        }
        
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        isOTPSent = true
        otpPhoneNumber = phoneNumber
        timeRemaining = 60
        isOTPVerified = false
        
        successMessage = "New OTP code sent to \(phoneNumber)."
        
        otpCode = ["", "", "", "", "", ""]
        
        isLoading = false
    }
    
    func register() async {
        guard isFormValid else {
            errorMessage = "Please fill all fields correctly"
            return
        }
        
        guard let department = selectedDepartment else {
            errorMessage = "Please select a department"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            try await authService.register(
                email: email,
                password: password,
                firstName: firstName,
                lastName: lastName,
                phoneNumber: phoneNumber,
                departmentId: department.id
            )
            
            registrationSuccessful = true
            successMessage = "Account created successfully! Please sign in."
            
        } catch let error as APIError {
            
            switch error {
            case .badRequest(let response):
                
                if response.message == "Bad request" {
                    errorMessage = "This email is already registered. Please use a different email or sign in."
                } else if let details = response.details,
                   let firstError = details.values.first?.first {
                    errorMessage = firstError
                } else {
                    errorMessage = response.message
                }
                
            case .conflict(let message):
                errorMessage = message
                
            default:
                errorMessage = error.errorMessage
            }
            
        } catch {
            errorMessage = "Registration failed. Please try again."
        }
        
        isLoading = false
    }
    
    func clearForm() {
        firstName = ""
        lastName = ""
        email = ""
        phoneNumber = ""
        otpCode = ["", "", "", "", "", ""]
        selectedDepartment = departments.first
        password = ""
        confirmPassword = ""
        agreedToTerms = false
        isOTPSent = false
        isOTPVerified = false
        timeRemaining = 0
        storedOTP = nil
        otpPhoneNumber = nil
        errorMessage = nil
        successMessage = nil
        phoneNumberError = nil
        showPhoneError = false
    }
}
