import SwiftUI
import MapKit

@Observable
final class MapViewModel {
    var selectedActivity: Activity?
    var showingActivityDetail = false
    var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    func focusOnActivity(_ activity: Activity) {
        selectedActivity = activity
        showingActivityDetail = true
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: activity.latitude, longitude: activity.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
    }

    func resetRegion() {
        region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
    }
}
