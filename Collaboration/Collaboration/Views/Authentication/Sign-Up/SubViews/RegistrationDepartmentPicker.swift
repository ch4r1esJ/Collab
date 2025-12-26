//
//  RegistrationDepartmentPicker.swift
//  medzineba2
//
//  Created by Rize on 20.12.25.
//

import SwiftUI

struct RegistrationDepartmentPicker: View {
    let departments: [DepartmentDto]
    @Binding var selectedDepartment: DepartmentDto?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 4) {
                Image(systemName: "building.2")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                Text("Department")
                    .font(.system(size: 14))
                    .foregroundColor(.primary)
            }
            
            Menu {
                ForEach(departments) { department in
                    Button(action: {
                        selectedDepartment = department
                    }) {
                        HStack {
                            Text(department.name)
                            if selectedDepartment?.id == department.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedDepartment?.name ?? "Select Department")
                        .foregroundColor(selectedDepartment == nil ? .gray : .primary)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                .padding()
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
