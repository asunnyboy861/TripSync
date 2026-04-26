import SwiftUI
import SwiftData

struct ShareView: View {
    let trip: Trip
    @Environment(\.modelContext) private var modelContext
    @State private var shareLink = ""
    @State private var accessLevel: TripMember.Role = .editor

    var body: some View {
        List {
            Section("Share Trip") {
                Picker("Access Level", selection: $accessLevel) {
                    Text("Can Edit").tag(TripMember.Role.editor)
                    Text("Can View").tag(TripMember.Role.viewer)
                    Text("Admin").tag(TripMember.Role.admin)
                }
                .pickerStyle(.segmented)

                if shareLink.isEmpty {
                    Button("Generate Share Link") {
                        generateShareLink()
                    }
                } else {
                    HStack {
                        Text(shareLink)
                            .font(.caption)
                            .lineLimit(1)
                            .truncationMode(.middle)
                        Spacer()
                        ShareLink(item: shareLink) {
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }

            Section("Members") {
                ForEach(trip.members) { member in
                    HStack {
                        Text(member.avatarEmoji)
                            .font(.title3)
                        VStack(alignment: .leading) {
                            Text(member.displayName)
                                .font(.subheadline)
                            Text(member.role.rawValue.capitalized)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        if member.isOwner {
                            Text("Owner")
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.accentColor.opacity(0.2))
                                .foregroundColor(.accentColor)
                                .cornerRadius(4)
                        }
                    }
                }
            }
        }
        .navigationTitle("Share")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func generateShareLink() {
        let token = UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(12).lowercased()
        trip.shareToken = String(token)
        shareLink = "https://tripsync.app/join?t=\(token)&a=\(accessLevel.rawValue)"
        try? modelContext.save()
    }
}
