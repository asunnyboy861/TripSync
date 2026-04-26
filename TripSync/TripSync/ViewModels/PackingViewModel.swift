import SwiftUI
import SwiftData

@Observable
final class PackingViewModel {
    var showingAddItem = false
    var newItemName = ""
    var newItemCategory: PackingItem.PackingCategory = .essentials

    func addItem(to trip: Trip, modelContext: ModelContext) {
        guard !newItemName.isEmpty else { return }

        let item = PackingItem(name: newItemName, category: newItemCategory)
        trip.packingItems.append(item)
        try? modelContext.save()

        resetForm()
    }

    func toggleItem(_ item: PackingItem, modelContext: ModelContext) {
        item.isChecked.toggle()
        try? modelContext.save()
    }

    func deleteItem(_ item: PackingItem, from trip: Trip, modelContext: ModelContext) {
        trip.packingItems.removeAll { $0.id == item.id }
        modelContext.delete(item)
        try? modelContext.save()
    }

    func addTemplate(_ template: PackingTemplate, to trip: Trip, modelContext: ModelContext) {
        for item in template.items {
            let packingItem = PackingItem(name: item.name, category: item.category)
            trip.packingItems.append(packingItem)
        }
        try? modelContext.save()
    }

    func packedCount(for trip: Trip) -> Int {
        trip.packingItems.filter { $0.isChecked }.count
    }

    func totalCount(for trip: Trip) -> Int {
        trip.packingItems.count
    }

    private func resetForm() {
        newItemName = ""
        newItemCategory = .essentials
        showingAddItem = false
    }
}

struct PackingTemplate {
    let name: String
    let items: [(name: String, category: PackingItem.PackingCategory)]

    static let beach = PackingTemplate(name: "Beach Trip", items: [
        ("Swimsuit", .clothing), ("Sunscreen", .toiletries), ("Sunglasses", .essentials),
        ("Beach towel", .essentials), ("Flip flops", .clothing), ("Hat", .clothing),
        ("Passport", .documents), ("Phone charger", .electronics)
    ])

    static let city = PackingTemplate(name: "City Break", items: [
        ("Walking shoes", .clothing), ("City map", .essentials), ("Portable charger", .electronics),
        ("Umbrella", .essentials), ("Camera", .electronics), ("Passport", .documents),
        ("Toothbrush", .toiletries), ("Jacket", .clothing)
    ])

    static let camping = PackingTemplate(name: "Camping", items: [
        ("Tent", .essentials), ("Sleeping bag", .essentials), ("Flashlight", .electronics),
        ("Bug spray", .toiletries), ("Hiking boots", .clothing), ("First aid kit", .essentials),
        ("Water bottle", .essentials), ("Fire starter", .other)
    ])

    static let allTemplates = [beach, city, camping]
}
