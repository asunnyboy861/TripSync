import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TripListView()
                .tabItem {
                    Label("Trips", systemImage: "globe")
                }
                .tag(0)

            NavigationStack {
                Text("Explore destinations coming soon")
                    .navigationTitle("Explore")
            }
            .tabItem {
                Label("Explore", systemImage: "magnifyingglass")
            }
            .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(2)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Trip.self, inMemory: true)
}
