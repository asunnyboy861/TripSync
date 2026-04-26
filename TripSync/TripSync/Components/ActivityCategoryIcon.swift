import SwiftUI

struct ActivityCategoryIcon: View {
    let category: ActivityCategory
    let size: CGFloat

    init(category: ActivityCategory, size: CGFloat = 32) {
        self.category = category
        self.size = size
    }

    var body: some View {
        Image(systemName: category.icon)
            .font(.system(size: size * 0.5))
            .foregroundColor(.white)
            .frame(width: size, height: size)
            .background(Color(hex: category.colorHex))
            .clipShape(Circle())
    }
}
