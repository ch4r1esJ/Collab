//
//  DateRangeFilter.swift
//  Collaboration
//
//  Created by Rize on 21.12.25.
//


import SwiftUI

struct DateRangeFilter: View {
    @Binding var range: DateRange
    
    var body: some View {
        Section("Date Range") {
            Picker("Date Range", selection: $range) {
                ForEach(DateRange.allCases, id: \.self) { option in
                    Text(option.displayName).tag(option)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

#Preview {
    Form {
        DateRangeFilter(range: .constant(.all))
    }
}
