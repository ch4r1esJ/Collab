//
//  RegistrationEmailField.swift
//  medzineba2
//
//  Created by Rize on 20.12.25.
//


import SwiftUI

struct RegistrationEmailField: View {
    @Binding var email: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email")
                .font(.system(size: 14))
                .foregroundColor(.primary)
            TextField("john.doe@company.com", text: $email)
                .textFieldStyle(AuthTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
        }
    }
}
