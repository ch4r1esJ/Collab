//
//  RegistrationConfirmPasswordField.swift
//  medzineba2
//
//  Created by Rize on 20.12.25.
//

import SwiftUI

struct RegistrationConfirmPasswordField: View {
    @Binding var confirmPassword: String
    @Binding var showConfirmPassword: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Confirm Password")
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                Spacer()
                Button(action: { showConfirmPassword.toggle() }) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            if showConfirmPassword {
                TextField("Confirm password", text: $confirmPassword)
                    .textFieldStyle(AuthTextFieldStyle())
            } else {
                SecureField("Confirm password", text: $confirmPassword)
                    .textFieldStyle(AuthTextFieldStyle())
            }
        }
    }
}
