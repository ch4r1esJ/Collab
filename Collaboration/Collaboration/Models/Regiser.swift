//
//  Regiser.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/20/25.
//

import Foundation

struct RegisterRequest: Encodable {
    let email: String
    let password: String
    let firstName: String
    let lastName: String
    let phoneNumber: String
    let departmentId: Int
}

struct DepartmentDto: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String
}

enum Department: String, Codable, CaseIterable {
    case hr = "HR"
    case engineering = "Engineering"
    case design = "Design"
    case marketing = "Marketing"
}
