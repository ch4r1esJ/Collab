//
//  AuthServiceProtocol.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

protocol AuthServiceProtocol {
    func login(email: String, password: String) async throws -> LoginResponse
    func register(email: String, password: String, fullName: String) async throws -> LoginResponse
}
