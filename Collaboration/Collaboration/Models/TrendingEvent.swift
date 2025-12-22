//
//  TrendingEvent.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/22/25.
//

import SwiftUI

struct TrendingEvent: Identifiable {
    let id = UUID()
    let title: String
    let date: String
}

let trendingEvents = [
    TrendingEvent(title: "Tech Talk: AI in Business", date: "Jan 26, 2025"),
    TrendingEvent(title: "Annual Hackathon", date: "Feb 10-12, 2025"),
    TrendingEvent(title: "Product Design Sync", date: "Mar 15, 2025")
]
