//
//  RegistrationNameFields.swift
//  medzineba2
//
//  Created by Rize on 20.12.25.
//

import SwiftUI

struct RegistrationNameFields: View {
    @Binding var firstName: String
    @Binding var lastName: String
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("First Name")
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                TextField("John", text: $firstName)
                    .textFieldStyle(AuthTextFieldStyle())
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Last Name")
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
                TextField("Doe", text: $lastName)
                    .textFieldStyle(AuthTextFieldStyle())
            }
        }
    }
}
