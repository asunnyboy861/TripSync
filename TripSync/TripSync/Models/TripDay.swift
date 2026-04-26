import SwiftData
import Foundation

@Model
final class TripDay {
    @Attribute(.unique) var id: UUID
    var date: Date
    var dayIndex: Int
    var notes: String

    @Relationship(deleteRule: .cascade, inverse: \Activity.tripDay) var activities: [Activity]
    var trip: Trip?

    init(date: Date = .now, dayIndex: Int = 0) {
        self.id = UUID()
        self.date = date
        self.dayIndex = dayIndex
        self.notes = ""
        self.activities = []
    }
}
