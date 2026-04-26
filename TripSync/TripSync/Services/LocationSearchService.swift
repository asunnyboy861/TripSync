import Foundation
import MapKit

final class LocationSearchService {
    static let shared = LocationSearchService()

    private init() {}

    func search(for query: String, region: MKCoordinateRegion) async throws -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region

        let search = MKLocalSearch(request: request)
        let response = try await search.start()

        return response.mapItems
    }

    func searchNearby(category: String, region: MKCoordinateRegion) async throws -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = category
        request.region = region

        let search = MKLocalSearch(request: request)
        let response = try await search.start()

        return response.mapItems
    }
}
