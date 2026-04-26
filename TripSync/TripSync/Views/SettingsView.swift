import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var purchaseManager = PurchaseManager()
    @State private var useCloudKit = false
    @State private var showingPaywall = false

    var body: some View {
        NavigationStack {
            List {
                Section("Subscription") {
                    if purchaseManager.isPro {
                        HStack {
                            Image(systemName: "crown.fill")
                                .foregroundColor(.yellow)
                            Text("TripSync Pro")
                                .fontWeight(.medium)
                            Spacer()
                            Text("Active")
                                .font(.caption)
                                .foregroundColor(.green)
                        }
                    } else {
                        Button {
                            showingPaywall = true
                        } label: {
                            HStack {
                                Image(systemName: "crown")
                                Text("Upgrade to Pro")
                            }
                        }
                    }

                    Button {
                        Task {
                            await purchaseManager.restorePurchases()
                        }
                    } label: {
                        Text("Restore Purchases")
                    }
                }

                Section("Sync") {
                    Toggle("iCloud Sync", isOn: $useCloudKit)
                    if useCloudKit {
                        Text("Your data will sync across all your devices")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Data is stored locally on this device")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(appVersion)
                            .foregroundColor(.secondary)
                    }

                    Link(destination: URL(string: "https://asunnyboy861.github.io/TripSync-pages/support.html")!) {
                        HStack {
                            Text("Support")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }

                    Link(destination: URL(string: "https://asunnyboy861.github.io/TripSync-pages/privacy.html")!) {
                        HStack {
                            Text("Privacy Policy")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }

                    Link(destination: URL(string: "https://asunnyboy861.github.io/TripSync-pages/terms.html")!) {
                        HStack {
                            Text("Terms of Use")
                            Spacer()
                            Image(systemName: "arrow.up.right.square")
                                .foregroundColor(.secondary)
                        }
                    }

                    NavigationLink {
                        ContactSupportView()
                    } label: {
                        Text("Contact Support")
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showingPaywall) {
                PaywallView(purchaseManager: purchaseManager)
            }
        }
    }

    private var appVersion: String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
        return "\(version) (\(build))"
    }
}
