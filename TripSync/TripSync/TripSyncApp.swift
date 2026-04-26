import SwiftUI
import SwiftData

@main
struct TripSyncApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            Trip.self,
            TripDay.self,
            Activity.self,
            TripMember.self,
            Expense.self,
            PackingItem.self,
            Poll.self,
            PollOption.self,
            Vote.self
        ])
    }
}
