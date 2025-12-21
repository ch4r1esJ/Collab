//
//  RegistrationDepartmentPicker.swift
//  medzineba2
//
//  Created by Rize on 20.12.25.
//

import SwiftUI

struct RegistrationDepartmentPicker: View {
    @Binding var selectedDepartment: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Department")
                .font(.system(size: 14))
                .foregroundColor(.primary)
            Menu {
                Button("Engineering") { selectedDepartment = "Engineering" }
                Button("Marketing") { selectedDepartment = "Marketing" }
                Button("Sales") { selectedDepartment = "Sales" }
                Button("Customer Service") { selectedDepartment = "Customer Service"}
                Button("IT") { selectedDepartment = "IT"}
                Button("HR") { selectedDepartment = "HR" }
            } label: {
                HStack {
                    Text(selectedDepartment)
                        .font(.system(size: 15))
                        .foregroundColor(selectedDepartment == "Select Department" ? .gray : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .frame(height: 48)
                .padding(.horizontal, 16)
                .background(Color.white)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                )
            }
        }
    }
}
