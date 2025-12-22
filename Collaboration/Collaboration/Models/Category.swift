//
//  Category.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//


import SwiftUI

struct Category: Identifiable {
    let id = UUID()
    let name: String
    let iconName: String
    let eventCount: Int
    
    // Sample data matching your image
    static let categories = [
        Category(name: "Team Building", iconName: "profile", eventCount: 12),
        Category(name: "Sports", iconName: "sport", eventCount: 8),
        Category(name: "Workshops", iconName: "workshop", eventCount: 18),
        Category(name: "Happy Fridays", iconName: "friday", eventCount: 4),
        Category(name: "Cultural", iconName: "laugh", eventCount: 6),
        Category(name: "Wellness", iconName: "wellness", eventCount: 9)
    ]
}
