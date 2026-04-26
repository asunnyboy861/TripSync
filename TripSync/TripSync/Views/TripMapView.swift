import SwiftUI
import MapKit

struct TripMapView: View {
    let trip: Trip
    @State private var position: MapCameraPosition = .automatic

    var body: some View {
        Map(position: $position) {
            ForEach(trip.days) { day in
                ForEach(day.activities) { activity in
                    Annotation(activity.title, coordinate: CLLocationCoordinate2D(latitude: activity.latitude, longitude: activity.longitude)) {
                        ActivityMarkerView(category: activity.category)
                    }
                }
            }
        }
        .overlay(alignment: .bottom) {
            if !allActivities.isEmpty {
                mapLegendView
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

struct ActivityMarkerView: View {
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
