import SwiftUI

@Observable
final class SettingsViewModel {
    var useCloudKit = false
    var showingPaywall = false
    var showingPrivacyPolicy = false
    var showingTermsOfUse = false

    var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
