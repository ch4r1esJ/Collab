//
//  SendOTPRequest.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/20/25.
//

import Foundation

struct OTPRequest: Encodable {
    let otp: String
}

struct OTPResponse: Codable {
    let isValid: Bool
}
