import SwiftUI
import SwiftData

struct TripDetailView: View {
    let trip: Trip
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ItineraryView(trip: trip)
                .tabItem {
                    Label("Itinerary", systemImage: "list.bullet.clipboard")
                }
                .tag(0)

            TripMapView(trip: trip)
                .tabItem {
                    Label("Map", systemImage: "map")
                }
                .tag(1)

            PollListView(trip: trip)
                .tabItem {
                    Label("Polls", systemImage: "chart.bar")
                }
                .tag(2)

            ExpenseView(trip: trip)
                .tabItem {
                    Label("Expenses", systemImage: "dollarsign.circle")
                }
                .tag(3)

            PackingListView(trip: trip)
                .tabItem {
                    Label("Packing", systemImage: "backpack")
                }
                .tag(4)
        }
        .navigationTitle(trip.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}
