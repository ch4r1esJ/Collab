//
//  SendOTPRequest.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/20/25.
//

import Foundation

// MARK: - Send OTP Request
struct SendOTPRequest: Encodable {
    let phoneNumber: String
}

// MARK: - Send OTP Response
struct SendOTPResponse: Decodable {
    let success: Bool
    let expiresAt: String
    let message: String?
}

// MARK: - Verify OTP Request
struct VerifyOTPRequest: Encodable {
    let phoneNumber: String
    let code: String
}

// MARK: - Verify OTP Response
struct VerifyOTPResponse: Decodable {
    let success: Bool
    let token: String?
    let message: String?
}

// MARK: - Resend OTP Request
struct ResendOTPRequest: Encodable {
    let phoneNumber: String
}

// MARK: - Resend OTP Response
//typealias ResendOTPResponse = SendOTPResponse
