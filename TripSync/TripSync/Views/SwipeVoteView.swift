import SwiftUI
import SwiftData

struct SwipeVoteView: View {
    let poll: Poll
    let viewModel: PollViewModel
    let voterID: String
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex = 0
    @State private var offset: CGSize = .zero
    @State private var isSwiped = false

    var body: some View {
        NavigationStack {
            ZStack {
                if currentIndex < poll.options.count {
                    let option = poll.options[currentIndex]

                    VStack {
                        Spacer()

                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemBackground))
                                .shadow(color: .black.opacity(0.1), radius: 10, y: 5)

                            VStack(spacing: 20) {
                                Image(systemName: poll.options[currentIndex].title.isEmpty ? "photo" : "mappin.and.ellipse")
                                    .font(.system(size: 80))
                                    .foregroundColor(.accentColor)

                                Text(option.title)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .multilineTextAlignment(.center)

                                Text("Swipe right to like, left to skip")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                        .frame(height: 400)
                        .offset(offset)
                        .rotationEffect(.degrees(Double(offset.width / 10)))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    offset = value.translation
                                }
                                .onEnded { value in
                                    if value.translation.width > 100 {
                                        vote(true)
                                    } else if value.translation.width < -100 {
                                        vote(false)
                                    }
                                    offset = .zero
                                }
                        )

                        HStack(spacing: 40) {
                            Button {
                                vote(false)
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .font(.system(size: 60))
                                    .foregroundColor(.red)
                            }

                            Button {
                                vote(true)
                            } label: {
                                Image(systemName: "heart.circle")
                                    .font(.system(size: 60))
                                    .foregroundColor(.green)
                            }
                        }
                        .padding(.top, 20)

                        Spacer()
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 80))
                            .foregroundColor(.green)
                        Text("All done!")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("You've voted on all options")
                            .foregroundColor(.secondary)
                        Button("See Results") {
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
            .navigationTitle("Swipe Vote")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private func vote(_ isUpvote: Bool) {
        guard currentIndex < poll.options.count else { return }
        let option = poll.options[currentIndex]
        viewModel.vote(on: option, voterID: voterID, isUpvote: isUpvote, modelContext: modelContext)
        currentIndex += 1
    }
}
