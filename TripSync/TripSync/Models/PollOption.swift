import SwiftData
import Foundation

@Model
final class PollOption {
    @Attribute(.unique) var id: UUID
    var title: String
    var subtitle: String?
    var voteCount: Int

    @Relationship(deleteRule: .cascade, inverse: \Vote.option) var votes: [Vote]
    var poll: Poll?

    init(title: String = "", subtitle: String? = nil) {
        self.id = UUID()
        self.title = title
        self.subtitle = subtitle
        self.voteCount = 0
        self.votes = []
    }
}
