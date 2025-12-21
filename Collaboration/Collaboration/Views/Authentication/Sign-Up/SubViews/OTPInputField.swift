//
//  OTPInputField.swift
//  medzineba2
//
//  Created by Rize on 20.12.25.
//

import SwiftUI

struct OTPInputField: View {
    @Binding var text: String
    
    var body: some View {
        TextField("", text: $text)
            .frame(width: 48, height: 56)
            .multilineTextAlignment(.center)
            .font(.system(size: 20, weight: .medium))
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(.systemGray4), lineWidth: 1)
            )
            .keyboardType(.numberPad)
            .onChange(of: text) { oldValue, newValue in
                if newValue.count > 1 {
                    text = String(newValue.prefix(1))
                }
            }
    }
}
