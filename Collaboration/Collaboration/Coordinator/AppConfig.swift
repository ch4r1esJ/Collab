//
//  AppConfig.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/23/25.
//

import Foundation

struct AppConfig {
    
    static let useRealBackend = true
    
    static func makeAuthService() -> AuthServiceProtocol {
        if useRealBackend {
            return RealAuthService()
        } else {
            return MockAuthService()
        }
    }
    
    static func makeEventService() -> EventServiceProtocol {
        if useRealBackend {
            return RealEventService()
        } else {
            return MockEventService()
        }
    }
    
    static let baseURL = "//https://localhost:7232/api/Events"
    static let timeout: TimeInterval = 10
}
