import SwiftData
import Foundation

enum ActivityCategory: String, Codable, CaseIterable {
    case food = "food"
    case accommodation = "accommodation"
    case transport = "transport"
    case attraction = "attraction"
    case shopping = "shopping"
    case activity = "activity"
    case nightlife = "nightlife"
    case other = "other"

    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .accommodation: return "bed.double"
        case .transport: return "car"
        case .attraction: return "mappin.and.ellipse"
        case .shopping: return "bag"
        case .activity: return "figure.hiking"
        case .nightlife: return "music.note"
        case .other: return "star"
        }
    }

    var colorHex: String {
        switch self {
        case .food: return "FF9500"
        case .accommodation: return "007AFF"
        case .transport: return "34C759"
        case .attraction: return "FF3B30"
        case .shopping: return "FF2D55"
        case .activity: return "5AC8FA"
        case .nightlife: return "5856D6"
        case .other: return "8E8E93"
        }
    }
}

@Model
final class Activity {
    @Attribute(.unique) var id: UUID
    var title: String
    var subtitle: String?
    var latitude: Double
    var longitude: Double
    var address: String?
    var startTime: Date?
    var endTime: Date?
    var categoryRaw: String
    var notes: String?
    var rating: Double?
    var order: Int
    var addedBy: String?
    var isLocked: Bool

    var tripDay: TripDay?

    var category: ActivityCategory {
        get { ActivityCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }

    init(title: String = "", latitude: Double = 0, longitude: Double = 0, category: ActivityCategory = .other) {
        self.id = UUID()
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
        self.categoryRaw = category.rawValue
        self.order = 0
        self.isLocked = false
    }
}
