import SwiftUI
import SwiftData

@Observable
final class ItineraryViewModel {
    var showingAddActivity = false
    var newActivityTitle = ""
    var newActivityCategory: ActivityCategory = .attraction
    var newActivityLatitude = 0.0
    var newActivityLongitude = 0.0
    var newActivityAddress = ""
    var newActivityStartTime = Date()
    var newActivityEndTime: Date?

    func addActivity(to day: TripDay, modelContext: ModelContext) {
        guard !newActivityTitle.isEmpty else { return }

        let activity = Activity(
            title: newActivityTitle,
            latitude: newActivityLatitude,
            longitude: newActivityLongitude,
            category: newActivityCategory
        )
        activity.address = newActivityAddress.isEmpty ? nil : newActivityAddress
        activity.startTime = newActivityStartTime
        activity.endTime = newActivityEndTime
        activity.order = day.activities.count

        day.activities.append(activity)
        try? modelContext.save()

        resetForm()
    }

    func deleteActivity(_ activity: Activity, from day: TripDay, modelContext: ModelContext) {
        day.activities.removeAll { $0.id == activity.id }
        modelContext.delete(activity)
        try? modelContext.save()
    }

    private func resetForm() {
        newActivityTitle = ""
        newActivityCategory = .attraction
        newActivityLatitude = 0
        newActivityLongitude = 0
        newActivityAddress = ""
        newActivityStartTime = Date()
        newActivityEndTime = nil
        showingAddActivity = false
    }
}
