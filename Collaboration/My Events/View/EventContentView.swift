//
//  EventContentView.swift
//  Collaboration
//
//  Created by Rize on 23.12.25.
//


import SwiftUI

struct EventContentView: View {
    let event: Event
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
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: 200)
            .overlay(
                Text("Event Banner Image")
                    .foregroundColor(.white)
                    .font(.headline)
            )
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
            
            divider
            
            VStack(alignment: .leading, spacing: 0) {
                agendaSection
            }
            .padding(.horizontal, 16)
            
            divider
            
            VStack(alignment: .leading, spacing: 16) {
                speakersSection
            }
            .padding(.horizontal, 16)
            
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
            ForEach(event.tags, id: \.title) { tag in
                TagView(tag: tag)
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
            InfoRow(icon: "calendar", text: event.date)
            InfoRow(icon: "clock", text: event.timeRange)
            InfoRow(icon: "mappin.and.ellipse", text: event.location)
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
        Button(action: { viewModel.registerForEvent() }) {
            HStack {
                if viewModel.isRegistering {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    Text("Registering...")
                } else {
                    Text("Register Now")
                }
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(viewModel.canRegister() ? Color.black : Color.gray)
            .cornerRadius(8)
        }
        .disabled(!viewModel.canRegister())
    }
    
    private var registrationNote: some View {
        Text(event.registrationDeadline)
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
