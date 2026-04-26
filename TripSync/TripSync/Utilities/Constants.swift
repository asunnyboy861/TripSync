import Foundation

enum Constants {
    static let bundlePrefix = "com.zzoutuo.TripSync"
    static let maxFreeTrips = 2

    enum ProductID {
        static let monthly = "com.zzoutuo.TripSync.pro.monthly"
        static let yearly = "com.zzoutuo.TripSync.pro.yearly"
        static let lifetime = "com.zzoutuo.TripSync.pro.lifetime"
        static let all = [monthly, yearly, lifetime]
    }

    enum Emoji {
        static let avatars = ["🌍", "✈️", "🏖️", "🗺️", "🎒", "🏕️", "🚀", "🌊", "🏔️", "🌴", "🦜", "⛵️"]
    }

    enum RandomName {
        static let adjectives = ["Happy", "Sunny", "Brave", "Chill", "Witty", "Swift", "Cosmic", "Dreamy"]
        static let nouns = ["Traveler", "Explorer", "Wanderer", "Voyager", "Nomad", "Adventurer", "Pilot", "Scout"]
    }
}
