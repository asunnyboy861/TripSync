import SwiftUI

struct ActivityCardView: View {
    let activity: Activity
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 4)
                .fill(Color(hex: activity.category.colorHex))
                .frame(width: 4)
                .padding(.vertical, 4)

            Image(systemName: activity.category.icon)
                .font(.title3)
                .foregroundColor(Color(hex: activity.category.colorHex))
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(.subheadline)
                    .fontWeight(.medium)

                if let address = activity.address {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin")
                            .font(.caption2)
                        Text(address)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }

                if let startTime = activity.startTime {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption2)
                        Text(startTime.timeString)
                            .font(.caption)
                    }
                    .foregroundColor(.secondary)
                }
            }

            Spacer()

            if activity.isLocked {
                Image(systemName: "lock.fill")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                withAnimation { onDelete() }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
