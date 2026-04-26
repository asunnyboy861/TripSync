import SwiftUI
import MapKit

struct MapView: View {
    let trip: Trip
    @State private var viewModel = MapViewModel()
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        Map(position: $position) {
            ForEach(trip.days) { day in
                ForEach(day.activities) { activity in
                    Annotation(activity.title, coordinate: CLLocationCoordinate2D(latitude: activity.latitude, longitude: activity.longitude)) {
                        MapMarkerView(category: activity.category)
                            .onTapGesture {
                                viewModel.focusOnActivity(activity)
                            }
                    }
                }
            }
        }
        .overlay(alignment: .bottom) {
            mapLegendView
        }
        .sheet(isPresented: $viewModel.showingActivityDetail) {
            if let activity = viewModel.selectedActivity {
                ActivityDetailView(activity: activity)
            }
        }
    }

    private var allActivities: [Activity] {
        trip.days.flatMap { $0.activities }
    }

    private var mapLegendView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(ActivityCategory.allCases, id: \.self) { cat in
                    let count = allActivities.filter { $0.category == cat }.count
                    if count > 0 {
                        HStack(spacing: 4) {
                            Circle()
                                .fill(Color(hex: cat.colorHex))
                                .frame(width: 8, height: 8)
                            Text("\(cat.rawValue.capitalized) (\(count))")
                                .font(.caption2)
                        }
                    }
                }
            }
            .padding(8)
            .background(.ultraThinMaterial)
            .cornerRadius(8)
        }
        .padding()
    }
}

struct MapMarkerView: View {
    let category: ActivityCategory

    var body: some View {
        Image(systemName: category.icon)
            .font(.caption)
            .foregroundColor(.white)
            .padding(6)
            .background(Color(hex: category.colorHex))
            .clipShape(Circle())
    }
}

struct ActivityDetailView: View {
    let activity: Activity
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    Text(activity.title)
                        .font(.headline)

                    if let address = activity.address {
                        LabeledContent("Address", value: address)
                    }

                    if let startTime = activity.startTime {
                        LabeledContent("Start", value: startTime.timeString)
                    }

                    if let endTime = activity.endTime {
                        LabeledContent("End", value: endTime.timeString)
                    }
                }

                Section("Category") {
                    Label(activity.category.rawValue.capitalized, systemImage: activity.category.icon)
                }
            }
            .navigationTitle(activity.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}
