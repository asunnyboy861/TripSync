import SwiftUI
import SwiftData

struct PollListView: View {
    let trip: Trip
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = PollViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if trip.polls.isEmpty {
                    ContentUnavailableView(
                        "No Polls Yet",
                        systemImage: "chart.bar",
                        description: Text("Create a poll to make group decisions")
                    )
                    .frame(maxWidth: 720)
                    .frame(maxWidth: .infinity)
                } else {
                    ForEach(trip.polls) { poll in
                        PollCardView(poll: poll, viewModel: viewModel)
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.showingCreatePoll = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $viewModel.showingCreatePoll) {
            CreatePollView(viewModel: viewModel, trip: trip)
        }
    }
}

struct PollCardView: View {
    let poll: Poll
    let viewModel: PollViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var voterID = UUID().uuidString

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
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

            let totalVotes = poll.options.reduce(0) { $0 + $1.voteCount }

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

            if poll.isActive {
                Button("Close Poll") {
                    viewModel.closePoll(poll, modelContext: modelContext)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        .frame(maxWidth: 720)
        .frame(maxWidth: .infinity)
    }
}

struct CreatePollView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var viewModel: PollViewModel
    let trip: Trip

    var body: some View {
        NavigationStack {
            Form {
                Section("Poll") {
                    TextField("Question", text: $viewModel.newPollQuestion)
                    Picker("Type", selection: $viewModel.newPollType) {
                        Text("Single Choice").tag(PollType.singleChoice)
                        Text("Multiple Choice").tag(PollType.multipleChoice)
                        Text("Swipe Vote").tag(PollType.swipeVote)
                    }
                }

                Section("Options") {
                    ForEach(viewModel.newOptions.indices, id: \.self) { index in
                        HStack {
                            Text(viewModel.newOptions[index])
                            Spacer()
                            Button {
                                viewModel.removeOption(at: index)
                            } label: {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                            }
                        }
                    }

                    HStack {
                        TextField("Add option", text: $viewModel.newOptionText)
                        Button("Add") {
                            viewModel.addOption()
                        }
                        .disabled(viewModel.newOptionText.isEmpty)
                    }
                }
            }
            .navigationTitle("Create Poll")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { viewModel.showingCreatePoll = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        viewModel.createPoll(for: trip, modelContext: modelContext)
                    }
                    .disabled(viewModel.newPollQuestion.isEmpty || viewModel.newOptions.count < 2)
                }
            }
        }
    }
}
