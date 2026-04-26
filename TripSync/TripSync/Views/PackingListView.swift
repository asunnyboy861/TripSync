import SwiftUI
import SwiftData

struct PackingListView: View {
    let trip: Trip
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = PackingViewModel()
    @State private var showingTemplates = false

    private var packedCount: Int {
        viewModel.packedCount(for: trip)
    }

    private var totalCount: Int {
        viewModel.totalCount(for: trip)
    }

    private var progress: Double {
        guard totalCount > 0 else { return 0 }
        return Double(packedCount) / Double(totalCount)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                packingProgressView

                if trip.packingItems.isEmpty {
                    ContentUnavailableView(
                        "No Items Yet",
                        systemImage: "backpack",
                        description: Text("Add items manually or use a template")
                    )
                    .frame(maxWidth: 720)
                    .frame(maxWidth: .infinity)
                } else {
                    let grouped = Dictionary(grouping: trip.packingItems) { $0.category }
                    ForEach(PackingItem.PackingCategory.allCases, id: \.self) { cat in
                        if let items = grouped[cat], !items.isEmpty {
                            PackingCategorySection(category: cat, items: items, trip: trip, viewModel: viewModel)
                        }
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    showingTemplates = true
                } label: {
                    Image(systemName: "list.bullet.rectangle")
                }
                Button {
                    viewModel.showingAddItem = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $viewModel.showingAddItem) {
            AddPackingItemView(viewModel: viewModel, trip: trip)
        }
        .sheet(isPresented: $showingTemplates) {
            PackingTemplateView(trip: trip, viewModel: viewModel)
        }
    }

    private var packingProgressView: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Packing Progress")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text("\(packedCount)/\(totalCount)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            ProgressView(value: progress)
                .tint(progress >= 1.0 ? .green : .accentColor)

            if progress >= 1.0 {
                Text("All packed! Ready to go!")
                    .font(.caption)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        .frame(maxWidth: 720)
        .frame(maxWidth: .infinity)
    }
}

struct PackingCategorySection: View {
    let category: PackingItem.PackingCategory
    let items: [PackingItem]
    let trip: Trip
    let viewModel: PackingViewModel
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(category.rawValue.capitalized, systemImage: category.icon)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)

            ForEach(items) { item in
                HStack {
                    Button {
                        viewModel.toggleItem(item, modelContext: modelContext)
                    } label: {
                        Image(systemName: item.isChecked ? "checkmark.circle.fill" : "circle")
                            .foregroundColor(item.isChecked ? .green : .secondary)
                    }

                    Text(item.name)
                        .font(.subheadline)
                        .strikethrough(item.isChecked)
                        .foregroundColor(item.isChecked ? .secondary : .primary)

                    Spacer()

                    if let emoji = item.assignedToEmoji {
                        Text(emoji)
                            .font(.caption)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 4, y: 2)
        .frame(maxWidth: 720)
        .frame(maxWidth: .infinity)
    }
}

struct AddPackingItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var viewModel: PackingViewModel
    let trip: Trip

    var body: some View {
        NavigationStack {
            Form {
                Section("Item") {
                    TextField("Item name", text: $viewModel.newItemName)
                    Picker("Category", selection: $viewModel.newItemCategory) {
                        ForEach(PackingItem.PackingCategory.allCases, id: \.self) { cat in
                            Label(cat.rawValue.capitalized, systemImage: cat.icon).tag(cat)
                        }
                    }
                }
            }
            .navigationTitle("Add Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { viewModel.showingAddItem = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.addItem(to: trip, modelContext: modelContext)
                    }
                    .disabled(viewModel.newItemName.isEmpty)
                }
            }
        }
    }
}

struct PackingTemplateView: View {
    @Environment(\.modelContext) private var modelContext
    let trip: Trip
    let viewModel: PackingViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                ForEach(PackingTemplate.allTemplates, id: \.name) { template in
                    Button {
                        viewModel.addTemplate(template, to: trip, modelContext: modelContext)
                        dismiss()
                    } label: {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(template.name)
                                    .font(.headline)
                                Text("\(template.items.count) items")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Image(systemName: "plus.circle")
                        }
                    }
                }
            }
            .navigationTitle("Templates")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
            }
        }
    }
}
