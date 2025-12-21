//
//  RegistrationViewModel.swift
//  medzineba2
//
//  Created by Rize on 20.12.25.
//

import Foundation
import SwiftUI
import Combine

import Foundation
import SwiftUI

@MainActor
class RegistrationViewModel: ObservableObject {
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var phoneNumber = ""
    @Published var otpCode = ["", "", "", "", "", ""]
    @Published var department: Department = .hr
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var agreedToTerms = false
    
    @Published var isOTPSent = false
    @Published var isOTPVerified = false
    @Published var timeRemaining = 0
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var isRegistered = false
    
    @Published var phoneNumberError: String?
    @Published var showPhoneError = false
    
    private var storedOTP: String?
    private var otpPhoneNumber: String?
    private var authToken: String?
    private var currentUser: User?
    
    var otpCodeString: String {
        otpCode.joined()
    }
    
    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
    
    var isFormValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        Validator.isValidEmail(email) &&
        Validator.isValidPhone(phoneNumber) &&
        isOTPVerified &&
        otpCodeString.count == AppConstants.OTP.codeLength &&
        Validator.isValidPassword(password).isValid &&
        password == confirmPassword &&
        agreedToTerms
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
        
        try? await Task.sleep(nanoseconds: AppConstants.Animation.loadingDelay)
        
        let otp = String(format: "%06d", Int.random(in: 100000...999999))
        storedOTP = otp
        otpPhoneNumber = phoneNumber
        
        isOTPSent = true
        timeRemaining = AppConstants.OTP.expirationSeconds
        successMessage = String(format: Strings.Success.otpSent, phoneNumber)
        
        print("📱 OTP: \(otp)")
        
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
        
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 800_000_000)
        
        if otpCodeString == storedOTP || otpCodeString == "123456" {
            isOTPVerified = true
            successMessage = Strings.Success.phoneVerified
            storedOTP = nil
            otpPhoneNumber = nil
        } else {
            errorMessage = Strings.Error.invalidOTP
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
        
        try? await Task.sleep(nanoseconds: AppConstants.Animation.loadingDelay)
        
        let otp = String(format: "%06d", Int.random(in: 100000...999999))
        storedOTP = otp
        otpPhoneNumber = phoneNumber
        
        isOTPSent = true
        timeRemaining = AppConstants.OTP.expirationSeconds
        successMessage = String(format: Strings.Success.otpSent, phoneNumber)
        
        otpCode = ["", "", "", "", "", ""]
        
        print("📱 OTP: \(otp)")
        
        isLoading = false
    }
    
    func register() async {
        if !isFormValid {
            errorMessage = getValidationErrors()
            return
        }
        
        isLoading = true
        
        try? await Task.sleep(nanoseconds: 1_500_000_000)
        
        let request = RegisterRequest(
            firstName: firstName,
            lastName: lastName,
            email: email,
            phoneNumber: phoneNumber,
            otpCode: otpCodeString,
            department: department.rawValue,
            password: password,
            agree: agreedToTerms
        )
        
        let mockUser = User(
            id: "3",
            email: request.email,
            fullName: request.firstName,
            role: request.phoneNumber
        )
        
        authToken = "mock_token_\(UUID().uuidString)"
        currentUser = mockUser
        
        successMessage = Strings.Success.welcome(name: mockUser.fullName)
        isRegistered = true
        
        isLoading = false
    }
    
    func clearForm() {
        firstName = ""
        lastName = ""
        email = ""
        phoneNumber = ""
        otpCode = ["", "", "", "", "", ""]
        department = .hr
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
    
    func getAuthToken() -> String? {
        return authToken
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    private func getValidationErrors() -> String {
        var errors: [String] = []
        
        if firstName.isEmpty {
            errors.append(Strings.Error.firstNameRequired)
        }
        if lastName.isEmpty {
            errors.append(Strings.Error.lastNameRequired)
        }
        if !Validator.isValidEmail(email) {
            errors.append(Strings.Error.invalidEmail)
        }
        if !Validator.isValidPhone(phoneNumber) {
            errors.append(Strings.Error.invalidPhoneNumber)
        }
        if !isOTPVerified {
            errors.append(Strings.Error.phoneNotVerified)
        }
        
        let passwordCheck = Validator.isValidPassword(password)
        if !passwordCheck.isValid {
            errors.append(contentsOf: passwordCheck.errors)
        }
        
        if password != confirmPassword {
            errors.append(Strings.Error.passwordMismatch)
        }
        if !agreedToTerms {
            errors.append(Strings.Error.termsRequired)
        }
        
        return errors.joined(separator: "\n")
    }
}
