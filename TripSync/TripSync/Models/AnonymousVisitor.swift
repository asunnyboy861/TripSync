import SwiftData
import Foundation

@Model
final class AnonymousVisitor {
    @Attribute(.unique) var id: UUID
    var displayName: String
    var avatarEmoji: String
    var visitToken: String
    var createdAt: Date
    var lastActiveAt: Date

    var trip: Trip?

    init(displayName: String, avatarEmoji: String, visitToken: String) {
        self.id = UUID()
        self.displayName = displayName
        self.avatarEmoji = avatarEmoji
        self.visitToken = visitToken
        self.createdAt = Date()
        self.lastActiveAt = Date()
    }
}
