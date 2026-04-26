import SwiftUI
import SwiftData

@Observable
final class SyncManager {
    var isSyncing = false
    var lastSyncDate: Date?
    var syncError: String?

    func toggleCloudKit(enabled: Bool) {
        if enabled {
            enableCloudKit()
        } else {
            disableCloudKit()
        }
    }

    private func enableCloudKit() {
        isSyncing = true
        lastSyncDate = Date()
        isSyncing = false
    }

    private func disableCloudKit() {
        lastSyncDate = nil
    }

    func triggerSync() {
        isSyncing = true
        lastSyncDate = Date()
        isSyncing = false
    }
}
