//
//  Category.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI

struct CategoryDto: Codable, Identifiable {
    let id: Int
    let title: String
    let totalEvents: Int
}
