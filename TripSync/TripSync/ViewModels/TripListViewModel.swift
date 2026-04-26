import SwiftUI
import SwiftData

@Observable
final class TripListViewModel {
    var showingCreateTrip = false
    var newTripName = ""
    var newTripDestination = ""
    var newTripStartDate = Date()
    var newTripEndDate = Date().addingTimeInterval(7 * 24 * 3600)

    func createTrip(modelContext: ModelContext) {
        guard !newTripName.isEmpty else { return }

        let trip = Trip(
            name: newTripName,
            destination: newTripDestination,
            startDate: newTripStartDate,
            endDate: newTripEndDate
        )

        let owner = TripMember(
            displayName: .randomName(),
            avatarEmoji: .randomEmoji(),
            role: .admin,
            isOwner: true
        )
        trip.members.append(owner)

        let calendar = Calendar.current
        var currentDate = newTripStartDate
        var index = 0
        while currentDate <= newTripEndDate {
            let day = TripDay(date: currentDate, dayIndex: index)
            trip.days.append(day)
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
            index += 1
        }

        modelContext.insert(trip)
        try? modelContext.save()

        resetForm()
    }

    func deleteTrip(_ trip: Trip, modelContext: ModelContext) {
        modelContext.delete(trip)
        try? modelContext.save()
    }

    private func resetForm() {
        newTripName = ""
        newTripDestination = ""
        newTripStartDate = Date()
        newTripEndDate = Date().addingTimeInterval(7 * 24 * 3600)
        showingCreateTrip = false
    }
}
