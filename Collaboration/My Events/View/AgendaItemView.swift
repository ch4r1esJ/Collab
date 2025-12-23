//
//  AgendaItemView.swift
//  Collaboration
//
//  Created by Rize on 23.12.25.
//


import SwiftUI

struct AgendaItemView: View {
    let item: AgendaItem
    let isLast: Bool
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            VStack(spacing: 0) {
                Circle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Text("\(item.id)")
                            .font(.system(size: 15))
                            .fontWeight(.medium)
                            .foregroundColor(.black)
                    )
                
                if !isLast {
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            
            VStack(alignment: .leading, spacing: 6) {
                Text("\(item.time) - \(item.title)")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Text(item.description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineSpacing(2)
            }
            .padding(.bottom, isLast ? 0 : 32)
        }
    }
}
