import SwiftUI
import SwiftData

struct JoinTripView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var token = ""
    @State private var displayName = ""
    @State private var avatarEmoji = "🌍"
    @State private var isJoining = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Trip Link") {
                    TextField("Enter trip token", text: $token)
                        .autocorrectionDisabled()
                }

                Section("Your Info") {
                    TextField("Display name", text: $displayName)
                    Picker("Avatar", selection: $avatarEmoji) {
                        ForEach(Constants.Emoji.avatars, id: \.self) { emoji in
                            Text(emoji).tag(emoji)
                        }
                    }
                    .pickerStyle(.wheel)
                }
            }
            .navigationTitle("Join Trip")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Join") {
                        joinTrip()
                    }
                    .disabled(token.isEmpty || displayName.isEmpty)
                }
            }
        }
    }

    private func joinTrip() {
        isJoining = true
        let visitor = AnonymousVisitor(
            displayName: displayName,
            avatarEmoji: avatarEmoji,
            visitToken: token
        )
        modelContext.insert(visitor)
        try? modelContext.save()
        isJoining = false
    }
}
