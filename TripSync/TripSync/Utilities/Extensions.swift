import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Date {
    var shortDateString: String {
        formatted(date: .abbreviated, time: .omitted)
    }

    var timeString: String {
        formatted(date: .omitted, time: .shortened)
    }
}

extension String {
    static func randomName() -> String {
        let adj = Constants.RandomName.adjectives.randomElement() ?? "Happy"
        let noun = Constants.RandomName.nouns.randomElement() ?? "Traveler"
        let num = Int.random(in: 1...99)
        return "\(adj) \(noun) \(num)"
    }

    static func randomEmoji() -> String {
        Constants.Emoji.avatars.randomElement() ?? "🌍"
    }
}
