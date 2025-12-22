//
//  TrendingEventCard.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/22/25.
//

import SwiftUI

struct TrendingEventCard: View {
    let event: EventDetailsDto
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AsyncImage(url: URL(string: event.imageUrl ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                default:
                    ZStack {
                        Color(.systemGray4)
                        Text("Event Image")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
            }
            .frame(height: 160)
            .clipped()
            
            VStack(alignment: .leading, spacing: 10) {
                Text(event.title)
                    .font(.headline)
                    .lineLimit(1)
                    .foregroundColor(.primary)
                
                HStack(spacing: 6) {
                    Image(systemName: "calendar")
                        .font(.caption)
                    
                    Text(formatDate(event.startDateTime))
                        .font(.caption)
                }
                .foregroundColor(.secondary)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color.white)
        }
        .frame(width: 280)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(.systemGray5), lineWidth: 1)
        )
    }
    
    private func formatDate(_ dateString: String) -> String {
        return dateString.prefix(10).replacingOccurrences(of: "-", with: " ")
    }
}
