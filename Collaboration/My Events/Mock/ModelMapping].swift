//
//  ModelMapping].swift
//  Collaboration
//
//  Created by Rize on 23.12.25.
//

import Foundation

// MARK: - Mapping Extensions

extension EventData {
    func toEvent() -> Event {
        return Event(
            id: id,
            title: title,
            description: description,
            bannerImageURL: bannerImageURL,
            tags: tags.map { $0.toEventTag() },
            date: date,
            startTime: startTime,
            endTime: endTime,
            location: location,
            totalSpots: totalSpots,
            registeredCount: registeredCount,
            registrationDeadline: registrationDeadline,
            agenda: agenda.map { $0.toAgendaItem() },
            speakers: speakers.map { $0.toSpeaker() }
        )
    }
}

extension TagData {
    func toEventTag() -> EventTag {
        let style: TagStyle = self.style.lowercased() == "dark" ? .dark : .light
        return EventTag(title: title, style: style)
    }
}

extension AgendaItemData {
    func toAgendaItem() -> AgendaItem {
        return AgendaItem(
            id: id,
            time: time,
            title: title,
            description: description
        )
    }
}

extension SpeakerData {
    func toSpeaker() -> Speaker {
        return Speaker(
            id: id,
            name: name,
            title: title,
            imageName: imageName
        )
    }
}
