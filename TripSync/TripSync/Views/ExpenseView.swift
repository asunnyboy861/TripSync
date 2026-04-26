import SwiftUI
import SwiftData

struct ExpenseView: View {
    let trip: Trip
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = ExpenseViewModel()

    private var totalAmount: Double {
        viewModel.totalExpenses(for: trip)
    }

    private var perPerson: Double {
        viewModel.perPersonShare(for: trip)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                expenseSummaryView

                if trip.expenses.isEmpty {
                    ContentUnavailableView(
                        "No Expenses",
                        systemImage: "dollarsign.circle",
                        description: Text("Track shared expenses and split costs")
                    )
                    .frame(maxWidth: 720)
                    .frame(maxWidth: .infinity)
                } else {
                    ForEach(trip.expenses.sorted(by: { $0.createdAt > $1.createdAt })) { expense in
                        ExpenseRowView(expense: expense) {
                            viewModel.deleteExpense(expense, from: trip, modelContext: modelContext)
                        }
                    }
                }
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    viewModel.showingAddExpense = true
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $viewModel.showingAddExpense) {
            AddExpenseView(viewModel: viewModel, trip: trip)
        }
    }

    private var expenseSummaryView: some View {
        VStack(spacing: 12) {
            Text("Total Expenses")
                .font(.caption)
                .foregroundColor(.secondary)
            Text(String(format: "$%.2f", totalAmount))
                .font(.title)
                .fontWeight(.bold)

            Divider()

            HStack {
                VStack {
                    Text("\(trip.members.count) members")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(String(format: "$%.2f each", perPerson))
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                Spacer()
                VStack {
                    Text("\(trip.expenses.count) expenses")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("tracked")
                        .font(.subheadline)
                }
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

struct ExpenseRowView: View {
    let expense: Expense
    let onDelete: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: expense.category.icon)
                .font(.title3)
                .foregroundColor(.accentColor)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                HStack(spacing: 4) {
                    Text(expense.paidByEmoji)
                        .font(.caption2)
                    Text(expense.paidByName)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Text(String(format: "$%.2f", expense.amount))
                .font(.subheadline)
                .fontWeight(.semibold)
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.05), radius: 3, y: 1)
        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
            Button(role: .destructive) {
                withAnimation { onDelete() }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .frame(maxWidth: 720)
        .frame(maxWidth: .infinity)
    }
}

struct AddExpenseView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var viewModel: ExpenseViewModel
    let trip: Trip

    var body: some View {
        NavigationStack {
            Form {
                Section("Expense") {
                    TextField("Title", text: $viewModel.newExpenseTitle)
                    TextField("Amount", text: $viewModel.newExpenseAmount)
                        .keyboardType(.decimalPad)
                    Picker("Category", selection: $viewModel.newExpenseCategory) {
                        ForEach(Expense.ExpenseCategory.allCases, id: \.self) { cat in
                            Label(cat.rawValue.capitalized, systemImage: cat.icon).tag(cat)
                        }
                    }
                }

                Section("Paid By") {
                    TextField("Name", text: $viewModel.newExpensePaidByName)
                    Picker("Currency", selection: $viewModel.newExpenseCurrency) {
                        Text("USD").tag("USD")
                        Text("EUR").tag("EUR")
                        Text("GBP").tag("GBP")
                        Text("JPY").tag("JPY")
                        Text("CNY").tag("CNY")
                    }
                }
            }
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { viewModel.showingAddExpense = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        viewModel.addExpense(to: trip, modelContext: modelContext)
                    }
                    .disabled(viewModel.newExpenseTitle.isEmpty || Double(viewModel.newExpenseAmount) == nil)
                }
            }
        }
    }
}
