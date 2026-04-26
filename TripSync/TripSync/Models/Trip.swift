import SwiftData
import Foundation

@Model
final class Trip {
    @Attribute(.unique) var id: UUID
    var name: String
    var destination: String
    var startDate: Date
    var endDate: Date
    var coverImageName: String?
    var shareToken: String?
    var isPublic: Bool
    var createdAt: Date
    var updatedAt: Date

    @Relationship(deleteRule: .cascade, inverse: \TripDay.trip) var days: [TripDay]
    @Relationship(deleteRule: .cascade, inverse: \TripMember.trip) var members: [TripMember]
    @Relationship(deleteRule: .cascade, inverse: \Expense.trip) var expenses: [Expense]
    @Relationship(deleteRule: .cascade, inverse: \PackingItem.trip) var packingItems: [PackingItem]
    @Relationship(deleteRule: .cascade, inverse: \Poll.trip) var polls: [Poll]

    init(name: String = "", destination: String = "", startDate: Date = .now, endDate: Date = .now) {
        self.id = UUID()
        self.name = name
        self.destination = destination
        self.startDate = startDate
        self.endDate = endDate
        self.isPublic = false
        self.createdAt = Date()
        self.updatedAt = Date()
        self.days = []
        self.members = []
        self.expenses = []
        self.packingItems = []
        self.polls = []
    }
}
