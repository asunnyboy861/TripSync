import SwiftUI
import StoreKit

struct PaywallView: View {
    @ObservedObject var purchaseManager: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @State private var selectedPlan: PlanType?

    enum PlanType {
        case monthly, yearly, lifetime
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerView

                    VStack(spacing: 12) {
                        if let product = purchaseManager.monthlyProduct {
                            planCard(
                                type: .monthly,
                                title: "Monthly",
                                price: product.displayPrice,
                                period: "/month",
                                badge: nil
                            )
                        }

                        if let product = purchaseManager.yearlyProduct {
                            planCard(
                                type: .yearly,
                                title: "Yearly",
                                price: product.displayPrice,
                                period: "/year",
                                badge: "Save 45%"
                            )
                        }

                        if let product = purchaseManager.lifetimeProduct {
                            planCard(
                                type: .lifetime,
                                title: "Lifetime",
                                price: product.displayPrice,
                                period: " one-time",
                                badge: "Best Value"
                            )
                        }
                    }
                    .padding(.horizontal)

                    subscribeButton

                    legalTextView
                }
                .padding(.vertical)
            }
            .navigationTitle("TripSync Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private var headerView: some View {
        VStack(spacing: 8) {
            Image(systemName: "crown.fill")
                .font(.system(size: 48))
                .foregroundColor(.yellow)

            Text("Unlock TripSync Pro")
                .font(.title2)
                .fontWeight(.bold)

            Text("Unlimited trips, iCloud sync, and more")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
    }

    private func planCard(type: PlanType, title: String, price: String, period: String, badge: String?) -> some View {
        Button {
            selectedPlan = type
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(title)
                            .font(.headline)
                        if let badge {
                            Text(badge)
                                .font(.caption2)
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.accentColor.opacity(0.2))
                                .foregroundColor(.accentColor)
                                .cornerRadius(4)
                        }
                    }
                    Text("\(price)\(period)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: selectedPlan == type ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(selectedPlan == type ? .accentColor : .secondary)
            }
            .padding()
            .background(selectedPlan == type ? Color.accentColor.opacity(0.1) : Color(.systemBackground))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(selectedPlan == type ? Color.accentColor : Color(.systemGray4), lineWidth: selectedPlan == type ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var subscribeButton: some View {
        Button {
            Task {
                guard let plan = selectedPlan else { return }
                var product: Product?
                switch plan {
                case .monthly: product = purchaseManager.monthlyProduct
                case .yearly: product = purchaseManager.yearlyProduct
                case .lifetime: product = purchaseManager.lifetimeProduct
                }
                if let product {
                    let success = await purchaseManager.purchase(product)
                    if success { dismiss() }
                }
            }
        } label: {
            if purchaseManager.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            } else {
                Text("Subscribe")
                    .fontWeight(.semibold)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(selectedPlan == nil ? Color.gray : Color.accentColor)
        .foregroundColor(.white)
        .cornerRadius(12)
        .padding(.horizontal)
        .disabled(selectedPlan == nil || purchaseManager.isLoading)
    }

    private var legalTextView: some View {
        VStack(spacing: 8) {
            Text("Payment will be charged to your Apple ID account at confirmation of purchase. Subscription automatically renews unless canceled at least 24 hours before the end of the current period. You can manage and cancel your subscriptions by going to your account settings on the App Store after purchase.")
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            HStack(spacing: 4) {
                Link("Privacy Policy", destination: URL(string: "https://asunnyboy861.github.io/TripSync-pages/privacy.html")!)
                Text("-")
                Link("Terms of Use", destination: URL(string: "https://asunnyboy861.github.io/TripSync-pages/terms.html")!)
            }
            .font(.caption2)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
}
