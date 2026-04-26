import SwiftData
import Foundation

enum PollType: String, Codable {
    case singleChoice = "single"
    case multipleChoice = "multiple"
    case swipeVote = "swipe"
}

@Model
final class Poll {
    @Attribute(.unique) var id: UUID
    var question: String
    var pollTypeRaw: String
    var isActive: Bool
    var createdAt: Date
    var createdBy: String?

    @Relationship(deleteRule: .cascade, inverse: \PollOption.poll) var options: [PollOption]
    var trip: Trip?

    var pollType: PollType {
        get { PollType(rawValue: pollTypeRaw) ?? .singleChoice }
        set { pollTypeRaw = newValue.rawValue }
    }

    init(question: String = "", pollType: PollType = .singleChoice) {
        self.id = UUID()
        self.question = question
        self.pollTypeRaw = pollType.rawValue
        self.isActive = true
        self.createdAt = Date()
        self.options = []
    }
}
