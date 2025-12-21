//
//  Regiser.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/20/25.
//

import Foundation

struct RegisterRequest: Codable {
    let firstName: String
    let lastName: String
    let email: String
    let phoneNumber: String
    let otpCode: String
    let department: String
    let password: String
    let agree: Bool
}

enum Department: String, Codable, CaseIterable {
    case hr = "HR"
    case engineering = "Engineering"
    case design = "Design"
    case marketing = "Marketing"
}
