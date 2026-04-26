import SwiftData
import Foundation

@Model
final class TripMember {
    @Attribute(.unique) var id: UUID
    var displayName: String
    var avatarEmoji: String
    var roleRaw: String
    var joinedAt: Date
    var isOwner: Bool

    var trip: Trip?

    enum Role: String, Codable {
        case viewer = "viewer"
        case editor = "editor"
        case admin = "admin"
    }

    var role: Role {
        get { Role(rawValue: roleRaw) ?? .viewer }
        set { roleRaw = newValue.rawValue }
    }

    init(displayName: String = "Traveler", avatarEmoji: String = "🌍", role: Role = .editor, isOwner: Bool = false) {
        self.id = UUID()
        self.displayName = displayName
        self.avatarEmoji = avatarEmoji
        self.roleRaw = role.rawValue
        self.joinedAt = Date()
        self.isOwner = isOwner
    }
}
