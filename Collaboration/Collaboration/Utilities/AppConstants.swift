//
//  AppConstants.swift
//  medzineba2
//
//  Created by Rize on 20.12.25.
//

import Foundation

enum AppConstants {
    enum OTP {
        static let expirationSeconds = 300
        static let codeLength = 6
    }
    
    enum Validation {
        static let minPasswordLength = 8
        static let minPhoneDigits = 10
    }
    
    enum Animation {
        static let loadingDelay: UInt64 = 1_000_000_000
    }
}
