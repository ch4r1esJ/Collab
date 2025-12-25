//
//  AuthServiceProtocol.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import Foundation

protocol AuthServiceProtocol {
    func register(email: String, password: String, firstName: String, lastName: String) async throws
    
    func login(email: String, password: String) async throws -> LoginResponse
    
    func verifyOTP(code: String) async throws -> Bool
    
    func sendPasswordResetLink(email: String) async throws
    
    func getCurrentUser() async throws -> UserProfileDto
}
