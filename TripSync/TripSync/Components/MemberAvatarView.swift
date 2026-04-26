import SwiftUI

struct MemberAvatarView: View {
    let emoji: String
    let name: String
    let size: CGFloat

    init(emoji: String, name: String, size: CGFloat = 32) {
        self.emoji = emoji
        self.name = name
        self.size = size
    }

    var body: some View {
        VStack(spacing: 2) {
            Text(emoji)
                .font(.system(size: size * 0.5))
                .frame(width: size, height: size)
                .background(Color(.systemGray5))
                .clipShape(Circle())
            Text(name)
                .font(.system(size: size * 0.3))
                .lineLimit(1)
                .truncationMode(.tail)
        }
    }
}
