//
//  EventContentView.swift
//  Collaboration
//
//  Created by Rize on 23.12.25.
//

import SwiftUI

struct EventContentView: View {
    let event: EventListDto
    @ObservedObject var viewModel: EventDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                eventBanner
                eventDetails
            }
        }
    }
    
    private var eventBanner: some View {
        AsyncImage(url: URL(string: event.imageUrl)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .overlay(
                    VStack {
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                        Text(event.title)
                            .foregroundColor(.white)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding()
                    }
                )
        }
        .frame(height: 200)
        .clipped()
    }
    
    private var eventDetails: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                eventTags
                eventTitle
                eventInfo
            }
            .padding(.horizontal, 16)
            
            divider
            
            VStack(alignment: .leading, spacing: 8) {
                registerButtonWithNote
            }
            .padding(.horizontal, 16)
            
            divider
            
            VStack(alignment: .leading, spacing: 8) {
                aboutSection
            }
            .padding(.horizontal, 16)
            
            if !event.agenda.isEmpty {
                divider
                
                VStack(alignment: .leading, spacing: 0) {
                    agendaSection
                }
                .padding(.horizontal, 16)
            }
            
            if !event.speakers.isEmpty {
                divider
                
                VStack(alignment: .leading, spacing: 16) {
                    speakersSection
                }
                .padding(.horizontal, 16)
            }
            
            divider
        }
    }
    
    private var divider: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.2))
            .frame(height: 1)
            .padding(.vertical, 16)
    }
    
    private var eventTags: some View {
        HStack(spacing: 8) {
            TagView(title: event.eventTypeName, style: .light)
            
            TagView(title: event.categoryTitle, style: .dark)
            
            ForEach(event.tags.prefix(2), id: \.self) { tag in
                TagView(title: tag, style: .light)
            }
        }
        .padding(.top, 16)
    }
    
    private var eventTitle: some View {
        Text(event.title)
            .font(.title2)
            .fontWeight(.bold)
    }
    
    private var eventInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            InfoRow(icon: "calendar", text: event.formattedDate)
            InfoRow(icon: "clock", text: event.timeRange)
            InfoRow(icon: "mappin.and.ellipse", text: "\(event.location) • \(event.venueName)")
            InfoRow(icon: "person.2", text: event.registrationInfo)
        }
    }
    
    private var registerButtonWithNote: some View {
        VStack(spacing: 8) {
            registerButton
            registrationNote
        }
    }
    
    private var registerButton: some View {
        let buttonState = viewModel.buttonState()
        
        return Button(action: {
            Task {
                switch buttonState {
                case .available:
                    await viewModel.registerForEvent()
                case .registered:
                    await viewModel.unregisterFromEvent()
                case .full:
                    break
                }
            }
        }) {
            HStack {
                if viewModel.isRegistering {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    Text("Processing...")
                } else {
                    Text(buttonText(for: buttonState))
                }
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(buttonColor(for: buttonState))
            .cornerRadius(8)
        }
        .disabled(!canTapButton(for: buttonState))
    }
    
    private func buttonText(for state: RegistrationButtonState) -> String {
        switch state {
        case .available:
            return "Register Now"
        case .registered:
            return "Cancel Registration"
        case .full:
            return "Event Full"
        }
    }
    
    private func buttonColor(for state: RegistrationButtonState) -> Color {
        switch state {
        case .available:
            return .black
        case .registered:
            return .red
        case .full:
            return .gray
        }
    }
    
    private func canTapButton(for state: RegistrationButtonState) -> Bool {
        switch state {
        case .available:
            return viewModel.canRegister()
        case .registered:
            return !viewModel.isRegistering
        case .full:
            return false
        }
    }
    
    private var registrationNote: some View {
        Text(event.registrationDeadlineText)
            .font(.system(size: 12))
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("About this event")
                .font(.headline)
                .fontWeight(.bold)
            
            Text(event.description)
                .font(.body)
                .foregroundColor(.secondary)
        }
    }
    
    private var agendaSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Agenda")
                .font(.headline)
                .fontWeight(.bold)
                .padding(.bottom, 16)
            
            ForEach(Array(event.agenda.enumerated()), id: \.element.id) { index, item in
                AgendaItemView(
                    item: item,
                    isLast: index == event.agenda.count - 1
                )
            }
        }
    }
    
    private var speakersSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Featured Speakers")
                .font(.system(size: 21))
                .fontWeight(.regular)
            
            ForEach(event.speakers, id: \.id) { speaker in
                SpeakerCardView(speaker: speaker)
            }
        }
        .padding(.bottom, 8)
    }
}

struct TagView: View {
    let title: String
    let style: TagStyle
    
    enum TagStyle {
        case light
        case dark
    }
    
    var body: some View {
        Text(title)
            .font(.caption)
            .fontWeight(.medium)
            .foregroundColor(textColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
    }
    
    private var backgroundColor: Color {
        switch style {
        case .light:
            return .white
        case .dark:
            return .black
        }
    }
    
    private var textColor: Color {
        switch style {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
}
