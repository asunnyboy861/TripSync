import SwiftUI

struct VoteResultBar: View {
    let option: PollOption
    let totalVotes: Int
    let isActive: Bool
    let onVote: () -> Void

    private var percentage: Double {
        guard totalVotes > 0 else { return 0 }
        return Double(option.voteCount) / Double(totalVotes)
    }

    var body: some View {
        Button(action: onVote) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(option.title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("\(option.voteCount) votes")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    if totalVotes > 0 {
                        Text("\(Int(percentage * 100))%")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.accentColor)
                    }
                }

                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.accentColor.opacity(0.6))
                            .frame(width: geo.size.width * percentage)
                    }
                }
                .frame(height: 6)
            }
        }
        .buttonStyle(.plain)
        .disabled(!isActive)
    }
}
