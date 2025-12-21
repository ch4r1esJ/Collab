//
//  RegistrationPasswordField.swift
//  medzineba2
//
//  Created by Rize on 20.12.25.
//

import SwiftUI

struct RegistrationPasswordField: View {
    @Binding var password: String
    @Binding var showPassword: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Password")
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                Spacer()
                Button(action: { showPassword.toggle() }) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            if showPassword {
                TextField("Create password", text: $password)
                    .textFieldStyle(AuthTextFieldStyle())
            } else {
                SecureField("Create password", text: $password)
                    .textFieldStyle(AuthTextFieldStyle())
            }
            
            Text("Password must be at least 8 characters with uppercase, lowercase, and number.")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
    }
}
