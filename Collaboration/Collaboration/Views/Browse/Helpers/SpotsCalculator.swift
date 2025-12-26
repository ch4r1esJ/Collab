//
//  SpotsCalculator.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//

struct SpotsCalculator {
    static func availableSpots(maxCapacity: Int, confirmed: Int) -> Int {
        return max(0, maxCapacity - confirmed)
    }
    
    static func isNearlyFull(maxCapacity: Int, confirmed: Int) -> Bool {
        let remaining = availableSpots(maxCapacity: maxCapacity, confirmed: confirmed)
        let threshold = Double(maxCapacity) * 0.2
        return Double(remaining) < threshold && remaining > 0
    }
    
    static func capacityPercentage(maxCapacity: Int, confirmed: Int) -> Double {
        guard maxCapacity > 0 else { return 0 }
        return Double(confirmed) / Double(maxCapacity)
    }
}
