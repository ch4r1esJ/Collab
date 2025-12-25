//
//  SpeakerCardView.swift
//  Collaboration
//
//  Created by Rize on 23.12.25.
//

import SwiftUI

struct SpeakerCardView: View {
    let speaker: SpeakerDto
    
    var body: some View {
        HStack(spacing: 12) {
            if let photoUrl = speaker.photoUrl, let url = URL(string: photoUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .overlay(
                            Text(speaker.name.prefix(1))
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        )
                }
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            } else {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(speaker.name.prefix(1))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.blue)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(speaker.name)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Text(speaker.role)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}
