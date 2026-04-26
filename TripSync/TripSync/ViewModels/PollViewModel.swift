import SwiftUI
import SwiftData

@Observable
final class PollViewModel {
    var showingCreatePoll = false
    var newPollQuestion = ""
    var newPollType: PollType = .singleChoice
    var newOptionText = ""
    var newOptions: [String] = []

    func addOption() {
        guard !newOptionText.isEmpty else { return }
        newOptions.append(newOptionText)
        newOptionText = ""
    }

    func removeOption(at index: Int) {
        guard newOptions.count > index else { return }
        newOptions.remove(at: index)
    }

    func createPoll(for trip: Trip, modelContext: ModelContext) {
        guard !newPollQuestion.isEmpty, newOptions.count >= 2 else { return }

        let poll = Poll(question: newPollQuestion, pollType: newPollType)
        for optionText in newOptions {
            let option = PollOption(title: optionText)
            poll.options.append(option)
        }
        trip.polls.append(poll)
        try? modelContext.save()

        resetForm()
    }

    func vote(on option: PollOption, voterID: String, isUpvote: Bool, modelContext: ModelContext) {
        let vote = Vote(voterID: voterID, isUpvote: isUpvote)
        option.votes.append(vote)
        option.voteCount = option.votes.filter { $0.isUpvote }.count
        try? modelContext.save()
    }

    func closePoll(_ poll: Poll, modelContext: ModelContext) {
        poll.isActive = false
        try? modelContext.save()
    }

    private func resetForm() {
        newPollQuestion = ""
        newPollType = .singleChoice
        newOptionText = ""
        newOptions = []
        showingCreatePoll = false
    }
}
