//
//  SpeakerCardView.swift
//  Collaboration
//
//  Created by Rize on 23.12.25.
//


import SwiftUI

struct SpeakerCardView: View {
    let speaker: Speaker
    
    var body: some View {
        HStack(spacing: 12) {
            Image(speaker.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(speaker.name)
                    .font(.system(size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Text(speaker.title)
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
    }
}
