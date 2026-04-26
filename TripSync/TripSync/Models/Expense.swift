import SwiftData
import Foundation

@Model
final class Expense {
    @Attribute(.unique) var id: UUID
    var title: String
    var amount: Double
    var currencyCode: String
    var categoryRaw: String
    var paidByName: String
    var paidByEmoji: String
    var splitTypeRaw: String
    var createdAt: Date

    var trip: Trip?

    enum ExpenseCategory: String, Codable, CaseIterable {
        case food = "food"
        case transport = "transport"
        case accommodation = "accommodation"
        case activity = "activity"
        case shopping = "shopping"
        case other = "other"

        var icon: String {
            switch self {
            case .food: return "fork.knife"
            case .transport: return "car"
            case .accommodation: return "bed.double"
            case .activity: return "ticket"
            case .shopping: return "bag"
            case .other: return "dollarsign.circle"
            }
        }

        var colorHex: String {
            switch self {
            case .food: return "FF9500"
            case .transport: return "34C759"
            case .accommodation: return "007AFF"
            case .activity: return "5856D6"
            case .shopping: return "FF2D55"
            case .other: return "8E8E93"
            }
        }
    }

    enum SplitType: String, Codable {
        case equal = "equal"
        case custom = "custom"
    }

    var category: ExpenseCategory {
        get { ExpenseCategory(rawValue: categoryRaw) ?? .other }
        set { categoryRaw = newValue.rawValue }
    }

    var splitType: SplitType {
        get { SplitType(rawValue: splitTypeRaw) ?? .equal }
        set { splitTypeRaw = newValue.rawValue }
    }

    init(title: String = "", amount: Double = 0, currencyCode: String = "USD", category: ExpenseCategory = .other, paidByName: String = "", paidByEmoji: String = "🌍") {
        self.id = UUID()
        self.title = title
        self.amount = amount
        self.currencyCode = currencyCode
        self.categoryRaw = category.rawValue
        self.paidByName = paidByName
        self.paidByEmoji = paidByEmoji
        self.splitTypeRaw = SplitType.equal.rawValue
        self.createdAt = Date()
    }
}
