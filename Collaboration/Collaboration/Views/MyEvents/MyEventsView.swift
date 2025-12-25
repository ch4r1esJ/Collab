//
//  MyEventsView.swift
//  Collaboration
//
//  Created by Charles Janjgava on 12/21/25.
//

import SwiftUI
import MapKit

struct MyEventsView: View {
    @StateObject private var viewModel = MyEventsViewModel()
    @State private var selectedMode: ViewMode = .calendar
    
    enum ViewMode {
        case list
        case calendar
    }
    
    var body: some View {
        VStack(spacing: 0) {
            headerSection
            viewToggleSection
            Divider()
            
            if viewModel.isLoading && viewModel.userRegistrations.isEmpty {
                loadingView
            } else if let errorMessage = viewModel.errorMessage {
                errorView(message: errorMessage)
            } else if viewModel.userRegistrations.isEmpty {
                emptyView
            } else {
                contentScrollView
            }
        }
        .background(Color(red: 249/255, green: 249/255, blue: 249/255))
        .task {
            await viewModel.fetchMyEvents()
        }
        .refreshable {
            await viewModel.refresh()
        }
    }
        
    private var headerSection: some View {
        Text("My Events")
            .font(.system(size: 28, weight: .bold))
            .padding(.top, 16)
            .padding(.bottom, 16)
    }
    
    private var viewToggleSection: some View {
        ViewToggle(selectedMode: $selectedMode)
            .padding(.horizontal, 20)
            .padding(.bottom, 12)
    }
        
    private var contentScrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                if let nextEvent = viewModel.nextUpcomingEvent {
                    upcomingEventSection(registration: nextEvent.registration, event: nextEvent.event)
                    Divider().padding(.vertical, 16)
                }
                
                if selectedMode == .calendar {
                    calendarSection
                    Divider().padding(.vertical, 16)
                }
                
                eventsListSection
            }
            .padding(.bottom, 100)
        }
    }
    
    private func upcomingEventSection(registration: UserRegistrationDto, event: EventListDto) -> some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("Next Upcoming Event")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 8)
            
            UpcomingEventCard(registration: registration, event: event, viewModel: viewModel)
                .padding(.horizontal, 20)
        }
    }
    
    private var calendarSection: some View {
        CalendarCard(viewModel: viewModel)
            .padding(.horizontal, 20)
    }
    
    private var eventsListSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(selectedMode == .calendar ? "Events on \(viewModel.selectedDateString)" : "My Registered Events")
                .font(.system(size: 15, weight: .semibold))
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            
            if selectedMode == .calendar {
                if viewModel.eventsForSelectedDate.isEmpty {
                    Text("No events on this date")
                        .font(.system(size: 15))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 20)
                } else {
                    EventsListCard(registrations: viewModel.eventsForSelectedDate, viewModel: viewModel)
                        .padding(.horizontal, 20)
                }
            } else {
                EventsListCard(registrations: viewModel.registrationsWithDetails, viewModel: viewModel)
                    .padding(.horizontal, 20)
            }
        }
    }
    
    private var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
            Text("Loading your events...")
                .foregroundColor(.secondary)
        }
        .frame(maxHeight: .infinity)
    }
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text(message)
                .font(.headline)
            
            Button("Retry") {
                Task {
                    await viewModel.fetchMyEvents()
                }
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .frame(maxHeight: .infinity)
    }
    
    private var emptyView: some View {
        VStack(spacing: 16) {
            Image(systemName: "calendar.badge.exclamationmark")
                .font(.system(size: 50))
                .foregroundColor(.gray)
            
            Text("No Registered Events")
                .font(.headline)
            
            Text("Events you register for will appear here")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxHeight: .infinity)
        .padding()
    }
}

struct ViewToggle: View {
    @Binding var selectedMode: MyEventsView.ViewMode
    
    var body: some View {
        HStack(spacing: 0) {
            toggleButton(title: "List", mode: .list)
            toggleButton(title: "Calendar", mode: .calendar)
        }
        .background(Color(red: 229/255, green: 229/255, blue: 234/255))
        .cornerRadius(10)
        .frame(height: 36)
    }
    
    private func toggleButton(title: String, mode: MyEventsView.ViewMode) -> some View {
        Button(action: { selectedMode = mode }) {
            Text(title)
                .font(.system(size: 17))
                .frame(maxWidth: .infinity)
                .frame(height: 36)
                .background(selectedMode == mode ? Color(red: 242/255, green: 242/255, blue: 247/255) : .clear)
                .foregroundColor(selectedMode == mode ? .black : Color(red: 142/255, green: 142/255, blue: 147/255))
                .cornerRadius(8)
        }
    }
}

struct UpcomingEventCard: View {
let registration: UserRegistrationDto
let event: EventListDto
@ObservedObject var viewModel: MyEventsViewModel

var body: some View {
    VStack(alignment: .leading, spacing: 9) {
        HStack {
            Text(event.title)
                .font(.system(size: 18, weight: .semibold))

            Spacer()

            Text(registration.displayStatus)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(statusColor.opacity(0.2))
                .foregroundColor(statusColor)
                .cornerRadius(4)
        }

        HStack(spacing: 8) {
            Image(systemName: "calendar")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
            Text(viewModel.formatEventDate(event.startDateTime))
                .font(.system(size: 15))
                .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
        }

        HStack(spacing: 8) {
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: 14))
                .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
            Text(event.location)
                .font(.system(size: 15))
                .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
        }

        mapPreview
    }
    .padding(14)
    .background(Color(red: 247/255, green: 247/255, blue: 247/255))
    .cornerRadius(12)
}

private var mapPreview: some View {
    ZStack {
        Color(red: 90/255, green: 90/255, blue: 90/255)

        VStack(spacing: 8) {
            Image(systemName: "map.fill")
                .font(.system(size: 40))
                .foregroundColor(.white.opacity(0.8))

            Text("Map Preview of Event Location")
                .font(.system(size: 15))
                .foregroundColor(.white)
        }
    }
    .frame(height: 180)
    .cornerRadius(8)
}

private var statusColor: Color {
    switch registration.statusName.lowercased() {
    case "confirmed":
        return .green
    case "waitlisted":
        return .orange
    default:
        return .gray
    }
}
}

struct CalendarCard: View {
    @ObservedObject var viewModel: MyEventsViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            calendarHeader
            weekdaysRow
            calendarGrid
        }
    }
    
    private var calendarHeader: some View {
        HStack {
            Button(action: { viewModel.previousMonth() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text(viewModel.currentMonthString)
                .font(.system(size: 17, weight: .semibold))
            
            Spacer()
            
            Button(action: { viewModel.nextMonth() }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)
            }
        }
        .padding(.bottom, 4)
    }
    
    private var weekdaysRow: some View {
        HStack(spacing: 0) {
            ForEach(["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"], id: \.self) { day in
                Text(day)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
                    .frame(maxWidth: .infinity)
            }
        }
    }
    
    private var calendarGrid: some View {
        let days = generateCalendarDays()
        
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: 7), spacing: 8) {
            ForEach(days, id: \.self) { date in
                if let date = date {
                    CalendarDayCell(
                        date: date,
                        isSelected: viewModel.isSelected(date),
                        hasEvent: viewModel.hasEvent(on: date),
                        isCurrentMonth: Calendar.current.isDate(date, equalTo: viewModel.currentMonth, toGranularity: .month),
                        onTap: {
                            viewModel.selectDate(date)
                        }
                    )
                } else {
                    Color.clear
                        .frame(height: 36)
                }
            }
        }
    }
    
    private func generateCalendarDays() -> [Date?] {
        var days: [Date?] = []
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: viewModel.currentMonth)
        
        guard let firstDayOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {
            return days
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: firstDayOfMonth) {
                days.append(date)
            }
        }
        
        return days
    }
}

struct CalendarDayCell: View {
    let date: Date
    let isSelected: Bool
    let hasEvent: Bool
    let isCurrentMonth: Bool
    let onTap: () -> Void
    
    private var day: Int {
        Calendar.current.component(.day, from: date)
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Text("\(day)")
                    .font(.system(size: 17, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(textColor)
                
                if hasEvent {
                    Circle()
                        .fill(dotColor)
                        .frame(width: 4, height: 4)
                } else {
                    Spacer().frame(height: 4)
                }
            }
            .frame(height: 36)
            .frame(maxWidth: .infinity)
            .background(isSelected ? .black : .clear)
            .cornerRadius(8)
        }
    }
    
    private var textColor: Color {
        if isSelected {
            return .white
        } else if !isCurrentMonth {
            return Color(red: 199/255, green: 199/255, blue: 204/255)
        } else {
            return .black
        }
    }
    
    private var dotColor: Color {
        isSelected ? .white : .black
    }
}

struct EventsListCard: View {
    let registrations: [(registration: UserRegistrationDto, event: EventListDto)]
    @ObservedObject var viewModel: MyEventsViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            ForEach(registrations, id: \.registration.id) { item in
                EventCards(registration: item.registration, event: item.event, viewModel: viewModel)
            }
        }
    }
}

struct EventCards: View {
    let registration: UserRegistrationDto
    let event: EventListDto
    @ObservedObject var viewModel: MyEventsViewModel
    
    private var timeComponents: (time: String, period: String) {
        viewModel.formatTime(event.startDateTime)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            timeColumn
            divider
            eventDetails
            Spacer()
        }
        .padding(16)
        .background(.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
    
    private var timeColumn: some View {
        VStack(spacing: 0) {
            Text(timeComponents.time)
                .font(.system(size: 13))
            Text(timeComponents.period)
                .font(.system(size: 13))
        }
        .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
        .frame(width: 45, alignment: .leading)
    }
    
    private var divider: some View {
        Rectangle()
            .fill(.black)
            .frame(width: 2)
    }
    
    private var eventDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(event.title)
                    .font(.system(size: 17, weight: .medium))
                
                Spacer()
                
                Text(registration.displayStatus)
                    .font(.caption)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(statusColor.opacity(0.2))
                    .foregroundColor(statusColor)
                    .cornerRadius(4)
            }
            
            HStack(spacing: 6) {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
                Text(event.eventTypeName)
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
            }
            
            HStack(spacing: 6) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
                Text(event.location)
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 142/255, green: 142/255, blue: 147/255))
            }
        }
    }
    
    private var statusColor: Color {
        switch registration.statusName.lowercased() {
        case "confirmed":
            return .green
        case "waitlisted":
            return .orange
        default:
            return .gray
        }
    }
}

#Preview {
    MyEventsView()
}
