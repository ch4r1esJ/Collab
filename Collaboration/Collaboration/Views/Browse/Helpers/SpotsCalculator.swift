//
//  SpotsCalculator.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import Foundation

struct SpotsCalculator {
    
    static func availableSpots(capacity: Int, confirmed: Int) -> Int {
        return max(0, capacity - confirmed)
    }
}
