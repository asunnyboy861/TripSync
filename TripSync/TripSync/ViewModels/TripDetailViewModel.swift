import SwiftUI
import SwiftData

@Observable
final class TripDetailViewModel {
    var showingShareSheet = false
    var showingEditTrip = false
    var editTripName = ""
    var editTripDestination = ""
    var editTripStartDate = Date()
    var editTripEndDate = Date()

    func loadTrip(_ trip: Trip) {
        editTripName = trip.name
        editTripDestination = trip.destination
        editTripStartDate = trip.startDate
        editTripEndDate = trip.endDate
    }

    func saveTrip(_ trip: Trip, modelContext: ModelContext) {
        trip.name = editTripName
        trip.destination = editTripDestination
        trip.startDate = editTripStartDate
        trip.endDate = editTripEndDate
        try? modelContext.save()
        showingEditTrip = false
    }
}
