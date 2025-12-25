//
//  ForgotPasswordView.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI

struct ForgotPasswordView: View {
    @State private var email = ""
    
    var body: some View {
        ZStack {
            backgroundColor
            
            VStack {
                ForgotPasswordCard(email: $email)
            }
            .frame(maxWidth: 450)
            .padding(20)
        }
    }
    
    private var backgroundColor: some View {
        Color(red: 245/255, green: 245/255, blue: 245/255)
            .ignoresSafeArea()
    }
}

struct ForgotPasswordCard: View {
    @Binding var email: String
    
    var body: some View {
        VStack(spacing: 0) {
            Head()
            EmailInputSection(email: $email)
            SendResetButton()
            BackToSignInButton()
        }
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 4)
    }
}

struct Head: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Forgot Password")
                .font(.system(size: 24, weight: .regular))
                .foregroundColor(.black)
            
            Text("Enter your email and we'll send you a link to reset your password.")
                .font(.system(size: 15))
                .foregroundColor(Color(red: 102/255, green: 102/255, blue: 102/255))
                .multilineTextAlignment(.center)
                .lineSpacing(2)
        }
        .padding(.top, 40)
        .padding(.horizontal, 32)
    }
}

struct EmailInputSection: View {
    @Binding var email: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Email")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.black)
            
            EmailTextField(email: $email)
        }
        .padding(.horizontal, 32)
        .padding(.top, 32)
    }
}

struct EmailTextField: View {
    @Binding var email: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "envelope")
                .font(.system(size: 16))
                .foregroundColor(Color(red: 153/255, green: 153/255, blue: 153/255))
            
            TextField("Enter your email", text: $email)
                .font(.system(size: 15))
                .foregroundColor(.black)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color(red: 229/255, green: 229/255, blue: 229/255), lineWidth: 1)
        )
        .cornerRadius(8)
    }
}

struct SendResetButton: View {
    var body: some View {
        Button(action: {}) {
            Text("Send Reset Link")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.black)
                .cornerRadius(8)
        }
        .padding(.horizontal, 32)
        .padding(.top, 24)
    }
}

struct BackToSignInButton: View {
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.left")
                    .font(.system(size: 14))
                Text("Back to Sign In")
                    .font(.system(size: 15))
            }
            .foregroundColor(.black)
        }
        .padding(.top, 20)
        .padding(.bottom, 40)
    }
}

#Preview {
    ForgotPasswordView()
}
