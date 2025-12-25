//
//  HeaderSection.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI

struct HeaderSection: View {
    @EnvironmentObject var coordinator: AppCoordinator
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            TitleView()
            
            Divider()
            
            WelcomeView(name: coordinator.currentUser?.firstName ?? "User")
        }
        .padding()
        .background(Color.white)
    }
}

struct WelcomeView: View {
    let name: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Welcome back, \(name)")
                .font(.system(size: 28, weight: .medium))
            
            Text("Stay connected with upcoming company events and activities.")
                .font(.system(size: 18))
                .foregroundColor(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

struct TitleView: View {
    var body: some View {
        HStack {
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.black)
                    .frame(width: 40, height: 40)
                
                Text("EventHub")
                    .font(.system(size: 25, weight: .medium))
                    .padding(.bottom, 15)
            }
            
            Spacer()
            
            HStack(spacing: 20) {
                Image(systemName: "bell")
                    .font(.system(size: 26))
                    .overlay(alignment: .topTrailing) {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 10, height: 10)
                            .offset(x: 1, y: -1)
                    }
                
                Image("profileicon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 45, height: 45)
            }
        }
    }
}

#Preview {
    HeaderSection()
}
