//
//  Validator.swift
//  medzineba2
//
//  Created by Rize on 20.12.25.
//


import Foundation

enum Validator {
    static func isValidEmail(_ email: String) -> Bool {
        guard !email.isEmpty else { return false }
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    static func isValidPassword(_ password: String) -> (isValid: Bool, errors: [String]) {
        var errors: [String] = []
        
        if password.count < 8 {
            errors.append("Must be 8+ characters")
        }
        if !password.contains(where: { $0.isUppercase }) {
            errors.append("Must contain uppercase")
        }
        if !password.contains(where: { $0.isLowercase }) {
            errors.append("Must contain lowercase")
        }
        if !password.contains(where: { $0.isNumber }) {
            errors.append("Must contain number")
        }
        
        return (errors.isEmpty, errors)
    }
    
    static func isValidPhone(_ phone: String) -> Bool {
        let digits = phone.filter { $0.isNumber }
        return digits.count >= 10
    }
}