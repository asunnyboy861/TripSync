import SwiftData
import Foundation

@Model
final class PackingItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var categoryRaw: String
    var isChecked: Bool
    var assignedToName: String?
    var assignedToEmoji: String?

    var trip: Trip?

    enum PackingCategory: String, Codable, CaseIterable {
        case essentials = "essentials"
        case clothing = "clothing"
        case toiletries = "toiletries"
        case electronics = "electronics"
        case documents = "documents"
        case other = "other"

        var icon: String {
            switch self {
            case .essentials: return "backpack"
            case .clothing: return "shirt"
            case .toiletries: return "drop"
            case .electronics: return "laptopcomputer.and.phone"
            case .documents: return "doc.text"
            case .other: return "square.on.square"
            }
        }
    }

    var category: PackingCategory {
        get { PackingCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }

    init(name: String = "", category: PackingCategory = .essentials) {
        self.id = UUID()
        self.name = name
        self.categoryRaw = category.rawValue
        self.isChecked = false
    }
}
