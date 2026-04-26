import SwiftUI
import SwiftData

struct ItineraryView: View {
    let trip: Trip
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ItineraryViewModel()
    @State private var selectedDay: TripDay?

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                tripHeaderView

                if trip.days.isEmpty {
                    ContentUnavailableView(
                        "No Days Planned",
                        systemImage: "calendar.badge.plus",
                        description: Text("Add dates when creating your trip")
                    )
                    .frame(maxWidth: 720)
                    .frame(maxWidth: .infinity)
                } else {
                    dayPickerView

                    if let selectedDay {
                        ItineraryDayView(day: selectedDay, viewModel: viewModel)
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.showingAddActivity = true
                } label: {
                    Image(systemName: "plus")
                }
                .disabled(selectedDay == nil)
            }
        }
        .sheet(isPresented: $viewModel.showingAddActivity) {
            AddActivityView(viewModel: viewModel, day: selectedDay)
        }
    }

    private var tripHeaderView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .foregroundColor(.accentColor)
                Text(trip.destination)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 16) {
                Label("\(trip.days.count) days", systemImage: "calendar")
                Label("\(trip.members.count) members", systemImage: "person.2")
                Label("\(trip.activitiesCount) activities", systemImage: "pin")
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .frame(maxWidth: 720)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }

    private var dayPickerView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(trip.days.sorted { $0.dayIndex < $1.dayIndex }) { day in
                    DayChipView(day: day, isSelected: selectedDay?.id == day.id) {
                        selectedDay = day
                    }
                }
            }
        }
        .frame(maxWidth: 720)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension Trip {
    var activitiesCount: Int {
        days.reduce(0) { $0 + $1.activities.count }
    }
}

struct DayChipView: View {
    let day: TripDay
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Text("Day \(day.dayIndex + 1)")
                    .font(.caption)
                    .fontWeight(isSelected ? .bold : .regular)
                Text(day.date.formatted(.dateTime.month(.abbreviated).day()))
                    .font(.caption2)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? Color.accentColor : Color(.systemGray5))
            .foregroundColor(isSelected ? .white : .primary)
            .cornerRadius(8)
        }
    }
}

struct ItineraryDayView: View {
    let day: TripDay
    let viewModel: ItineraryViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(spacing: 12) {
            if day.activities.isEmpty {
                ContentUnavailableView(
                    "No Activities",
                    systemImage: "plus.circle",
                    description: Text("Tap + to add your first activity")
                )
            } else {
                ForEach(day.activities.sorted { $0.order < $1.order }) { activity in
                    ActivityCardView(activity: activity) {
                        viewModel.deleteActivity(activity, from: day, modelContext: modelContext)
                    }
                }
            }
        }
        .frame(maxWidth: 720)
        .frame(maxWidth: .infinity)
    }
}

struct AddActivityView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var viewModel: ItineraryViewModel
    let day: TripDay?

    var body: some View {
        NavigationStack {
            Form {
                Section("Activity") {
                    TextField("Title", text: $viewModel.newActivityTitle)
                    Picker("Category", selection: $viewModel.newActivityCategory) {
                        ForEach(ActivityCategory.allCases, id: \.self) { cat in
                            Label(cat.rawValue.capitalized, systemImage: cat.icon).tag(cat)
                        }
                    }
                }

                Section("Location") {
                    TextField("Address", text: $viewModel.newActivityAddress)
                }

                Section("Time") {
                    DatePicker("Start", selection: $viewModel.newActivityStartTime, displayedComponents: .hourAndMinute)
                }
            }
            .navigationTitle("Add Activity")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { viewModel.showingAddActivity = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        if let day {
                            viewModel.addActivity(to: day, modelContext: modelContext)
                        }
                    }
                    .disabled(viewModel.newActivityTitle.isEmpty)
                }
            }
        }
    }
}
