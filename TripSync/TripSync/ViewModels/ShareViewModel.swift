import SwiftUI
import SwiftData

@Observable
final class ShareViewModel {
    var shareLink = ""
    var selectedRole: TripMember.Role = .editor
    var showingGeneratedLink = false

    func generateShareLink(for trip: Trip, modelContext: ModelContext) {
        let token = UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(12).lowercased()
        trip.shareToken = String(token)
        shareLink = "https://tripsync.app/join?t=\(token)&a=\(selectedRole.rawValue)"
        showingGeneratedLink = true
        try? modelContext.save()
    }

    func copyLink() {
        UIPasteboard.general.string = shareLink
    }
}
