//
//  MockAuthService.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/20/25.
//

//class MockAuthService {
//    func login(password: String, email: String) async throws -> AuthResponse  {
//        
//        if password == "Password" && email == email {
//            return AuthResponse(token: "testToken", user: User(id: <#T##UUID#>, email: <#T##String#>, firstName: <#T##String#>, fullName: <#T##String#>, department: <#T##String?#>))
//        }
//    }
//}

import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    private let tokenKey = "authToken"
    private let userIdKey = "userId"
    
    private init() {}
    
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    func saveUserId(_ userId: Int) {
        UserDefaults.standard.set(userId, forKey: userIdKey)
    }
    
    func getUserId() -> Int? {
        return UserDefaults.standard.integer(forKey: userIdKey)
    }
    
    func deleteToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
        UserDefaults.standard.removeObject(forKey: userIdKey)
    }
    
    func isLoggedIn() -> Bool {
        return getToken() != nil
    }
}
