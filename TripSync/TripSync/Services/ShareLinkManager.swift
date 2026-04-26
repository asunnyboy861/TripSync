import Foundation

final class ShareLinkManager {
    static let shared = ShareLinkManager()

    private init() {}

    func generateToken() -> String {
        UUID().uuidString.replacingOccurrences(of: "-", with: "").prefix(12).lowercased()
    }

    func buildShareLink(token: String, accessLevel: String) -> String {
        "https://tripsync.app/join?t=\(token)&a=\(accessLevel)"
    }

    func parseShareLink(_ url: URL) -> (token: String, accessLevel: String)? {
        guard url.host == "tripsync.app",
              url.path == "/join",
              let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems else {
            return nil
        }

        let token = queryItems.first { $0.name == "t" }?.value ?? ""
        let accessLevel = queryItems.first { $0.name == "a" }?.value ?? "editor"

        guard !token.isEmpty else { return nil }
        return (token: token, accessLevel: accessLevel)
    }
}
