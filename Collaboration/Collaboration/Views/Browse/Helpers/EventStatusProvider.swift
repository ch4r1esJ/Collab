//
//  EventStatusProvider.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

import SwiftUI

struct EventStatusProvider {
    
    static func statusInfo(isFull: Bool, confirmedCount: Int, capacity: Int) -> (label: String, color: Color) {
        if isFull {
            return ("Full", .red)
        }
        
        let filledPercentage = Double(confirmedCount) / Double(capacity)
        
        if filledPercentage > 0.8 {
            return ("Waitlist", .orange)
        }
        
        return ("Available", .green)
    }
}
