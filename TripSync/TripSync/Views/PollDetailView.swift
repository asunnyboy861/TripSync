import SwiftUI
import SwiftData

struct PollDetailView: View {
    let poll: Poll
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = PollViewModel()
    @State private var voterID = UUID().uuidString
    @State private var showingSwipeVote = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                pollHeaderView

                if poll.pollType == .swipeVote {
                    swipeVoteButton
                } else {
                    ForEach(poll.options) { option in
                        VoteResultBar(
                            option: option,
                            totalVotes: totalVotes,
                            isActive: poll.isActive
                        ) {
                            if poll.isActive {
                                viewModel.vote(on: option, voterID: voterID, isUpvote: true, modelContext: modelContext)
                            }
                        }
                    }
                }

                if poll.isActive {
                    Button("Close Poll") {
                        viewModel.closePoll(poll, modelContext: modelContext)
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle(poll.question)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingSwipeVote) {
            SwipeVoteView(poll: poll, viewModel: viewModel, voterID: voterID)
        }
    }

    private var totalVotes: Int {
        poll.options.reduce(0) { $0 + $1.voteCount }
    }

    private var pollHeaderView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(poll.question)
                    .font(.headline)
                Spacer()
                if poll.isActive {
                    Text("Active")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.green.opacity(0.2))
                        .foregroundColor(.green)
                        .cornerRadius(4)
                } else {
                    Text("Closed")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.gray)
                        .cornerRadius(4)
                }
            }

            Text("\(poll.options.count) options • \(totalVotes) votes")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: 720)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var swipeVoteButton: some View {
        Button {
            showingSwipeVote = true
        } label: {
            Label("Swipe to Vote", systemImage: "hand.tap")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple.opacity(0.1))
                .foregroundColor(.purple)
                .cornerRadius(12)
        }
        .frame(maxWidth: 720)
        .frame(maxWidth: .infinity)
    }
}
