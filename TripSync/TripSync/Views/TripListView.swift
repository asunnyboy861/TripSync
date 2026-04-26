import SwiftUI
import SwiftData

struct TripListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Trip.updatedAt, order: .reverse) private var trips: [Trip]
    @State private var viewModel = TripListViewModel()

    var body: some View {
        NavigationStack {
            Group {
                if trips.isEmpty {
                    ContentUnavailableView(
                        "No Trips Yet",
                        systemImage: "globe.desk",
                        description: Text("Create your first trip and start planning together")
                    )
                } else {
                    List {
                        ForEach(trips) { trip in
                            NavigationLink(destination: TripDetailView(trip: trip)) {
                                TripRowView(trip: trip)
                            }
                        }
                        .onDelete(perform: deleteTrips)
                    }
                }
            }
            .navigationTitle("TripSync")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        viewModel.showingCreateTrip = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingCreateTrip) {
                CreateTripView(viewModel: viewModel)
            }
        }
    }

    private func deleteTrips(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                viewModel.deleteTrip(trips[index], modelContext: modelContext)
            }
        }
    }
}

struct TripRowView: View {
    let trip: Trip

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(trip.name)
                    .font(.headline)
                Spacer()
                if !trip.members.isEmpty {
                    HStack(spacing: -6) {
                        ForEach(trip.members.prefix(3)) { member in
                            Text(member.avatarEmoji)
                                .font(.caption)
                                .frame(width: 24, height: 24)
                                .background(Color(.systemGray5))
                                .clipShape(Circle())
                        }
                        if trip.members.count > 3 {
                            Text("+\(trip.members.count - 3)")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }

            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(trip.destination)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            HStack {
                Image(systemName: "calendar")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("\(trip.startDate.shortDateString) - \(trip.endDate.shortDateString)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

struct CreateTripView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var viewModel: TripListViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section("Trip Details") {
                    TextField("Trip name", text: $viewModel.newTripName)
                    TextField("Destination", text: $viewModel.newTripDestination)
                }

                Section("Dates") {
                    DatePicker("Start", selection: $viewModel.newTripStartDate, displayedComponents: .date)
                    DatePicker("End", selection: $viewModel.newTripEndDate, in: viewModel.newTripStartDate..., displayedComponents: .date)
                }
            }
            .navigationTitle("New Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { viewModel.showingCreateTrip = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        viewModel.createTrip(modelContext: modelContext)
                    }
                    .disabled(viewModel.newTripName.isEmpty)
                }
            }
        }
    }
}
