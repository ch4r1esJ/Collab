//
//  Strings.swift
//  medzineba2
//
//  Created by Rize on 20.12.25.
//

import Foundation

enum Strings {
    enum Error {
        static let fillAllFields = "Please fill all fields correctly"
        static let invalidEmail = "Please enter a valid email address"
        static let invalidCredentials = "Invalid email or password"
        static let phoneNumberRequired = "Please enter phone number"
        static let invalidPhoneNumber = "Invalid phone number (min 10 digits)"
        static let otpIncomplete = "Please enter all 6 digits"
        static let invalidOTP = "Invalid OTP code"
        static let phoneNumberMismatch = "Phone number mismatch"
        static let phoneNotFound = "Phone number not found"
        static let phoneNotVerified = "Phone must be verified"
        static let passwordMismatch = "Passwords must match"
        static let termsRequired = "Must agree to Terms"
        static let firstNameRequired = "First name required"
        static let lastNameRequired = "Last name required"
        static let onlyNumbersAllowed = "Only numbers are allowed"
    }
    
    enum Success {
        static let otpSent = "OTP sent to %@"
        static let phoneVerified = "Phone number verified"
        static let passwordResetSent = "Password reset link sent to %@"
        static func welcome(name: String) -> String {
            "Welcome, \(name)!"
        }
    }
}
