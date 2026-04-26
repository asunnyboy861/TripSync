import SwiftUI

struct ShareLinkCard: View {
    let link: String
    let accessLevel: String
    let onCopy: () -> Void
    let onShare: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "link")
                    .font(.title3)
                    .foregroundColor(.accentColor)
                Text("Share Link")
                    .font(.headline)
            }

            Text(link)
                .font(.caption)
                .lineLimit(2)
                .truncationMode(.middle)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)

            HStack {
                Button(action: onCopy) {
                    Label("Copy", systemImage: "doc.on.doc")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                Button(action: onShare) {
                    Label("Share", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }

            HStack {
                Image(systemName: "info.circle")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text("Anyone with this link can \(accessLevel)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
    }
}
