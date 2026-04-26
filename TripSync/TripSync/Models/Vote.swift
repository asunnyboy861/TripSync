import SwiftData
import Foundation

@Model
final class Vote {
    @Attribute(.unique) var id: UUID
    var voterID: String
    var isUpvote: Bool
    var createdAt: Date

    var option: PollOption?

    init(voterID: String = "", isUpvote: Bool = true) {
        self.id = UUID()
        self.voterID = voterID
        self.isUpvote = isUpvote
        self.createdAt = Date()
    }
}
