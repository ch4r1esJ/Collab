//
//  MockAuthService.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/20/25.
//

import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private let keychain = KeychainManager.shared
    
    private let tokenKey = "auth_token"
    private let tokenExpiryKey = "token_expiry"
    private let userKey = "current_user"
    
    private init() {}
    
    
    func saveToken(_ token: String, expiresAt: String? = nil) {
        keychain.save(token, for: tokenKey)
        
        if let expiresAt = expiresAt {
            keychain.save(expiresAt, for: tokenExpiryKey)
        }
    }
    
    func getToken() -> String? {
        return keychain.retrieveString(for: tokenKey)
    }
    
    func clearToken() {
        keychain.delete(tokenKey)
        keychain.delete(tokenExpiryKey)
    }
    
    func isTokenExpired() -> Bool {
        guard let expiryString = keychain.retrieveString(for: tokenExpiryKey),
              let expiryDate = ISO8601DateFormatter().date(from: expiryString) else {
            return false
        }
        return Date() > expiryDate
    }
    
    func saveUser(_ user: UserProfileDto) {
        if let encoded = try? JSONEncoder().encode(user),
           let jsonString = String(data: encoded, encoding: .utf8) {
            keychain.save(jsonString, for: userKey)
        }
    }
    
    func getUser() -> UserProfileDto? {
        guard let jsonString = keychain.retrieveString(for: userKey),
              let data = jsonString.data(using: .utf8),
              let user = try? JSONDecoder().decode(UserProfileDto.self, from: data) else {
            return nil
        }
        return user
    }
    
    func getUserId() -> Int? {
        return getUser()?.id
    }
    
    func clearUser() {
        keychain.delete(userKey)
    }
    
    func clearAll() {
        clearToken()
        clearUser()
    }
}
