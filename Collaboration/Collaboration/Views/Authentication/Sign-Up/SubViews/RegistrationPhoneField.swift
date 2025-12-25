//
//  RegistrationPhoneField.swift
//  medzineba2
//
//  Created by Rize on 20.12.25.
//

import SwiftUI

struct RegistrationPhoneField: View {
    @Binding var phoneNumber: String
    @State private var hasInvalidInput = false

    let onSendOTP: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Phone Number")
                .font(.system(size: 14))
                .foregroundColor(.primary)
            HStack(spacing: 12) {
                TextField("+1 (000) 000-0000", text: $phoneNumber)
                    .textFieldStyle(AuthTextFieldStyle())
                    .keyboardType(.phonePad)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(hasInvalidInput ? Color.red : Color.clear, lineWidth: 1)
                    )
                    .onChange(of: phoneNumber) { oldValue, newValue in
                        let filtered = newValue.filter { $0.isNumber || $0 == "+" || $0 == " " || $0 == "-" || $0 == "(" || $0 == ")" }
                        if filtered != newValue {
                            phoneNumber = filtered
                            hasInvalidInput = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                hasInvalidInput = false
                            }
                        }
                    }
                
                Button(action: onSendOTP) {
                    Text("Send OTP")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(height: 48)
                        .padding(.horizontal, 20)
                        .background(Color.white)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                }
            }
            
            if hasInvalidInput {
                Text("Only numbers are allowed")
                    .font(.system(size: 12))
                    .foregroundColor(.red)
            }
        }
    }
}
