import SwiftUI
import SwiftData

@Observable
final class ExpenseViewModel {
    var showingAddExpense = false
    var newExpenseTitle = ""
    var newExpenseAmount = ""
    var newExpenseCategory: Expense.ExpenseCategory = .food
    var newExpensePaidByName = ""
    var newExpensePaidByEmoji = "🌍"
    var newExpenseCurrency = "USD"

    func addExpense(to trip: Trip, modelContext: ModelContext) {
        guard !newExpenseTitle.isEmpty, let amount = Double(newExpenseAmount), amount > 0 else { return }

        let expense = Expense(
            title: newExpenseTitle,
            amount: amount,
            currencyCode: newExpenseCurrency,
            category: newExpenseCategory,
            paidByName: newExpensePaidByName.isEmpty ? .randomName() : newExpensePaidByName,
            paidByEmoji: newExpensePaidByEmoji
        )
        trip.expenses.append(expense)
        try? modelContext.save()

        resetForm()
    }

    func deleteExpense(_ expense: Expense, from trip: Trip, modelContext: ModelContext) {
        trip.expenses.removeAll { $0.id == expense.id }
        modelContext.delete(expense)
        try? modelContext.save()
    }

    func totalExpenses(for trip: Trip) -> Double {
        trip.expenses.reduce(0) { $0 + $1.amount }
    }

    func perPersonShare(for trip: Trip) -> Double {
        let memberCount = max(trip.members.count, 1)
        return totalExpenses(for: trip) / Double(memberCount)
    }

    private func resetForm() {
        newExpenseTitle = ""
        newExpenseAmount = ""
        newExpenseCategory = .food
        newExpensePaidByName = ""
        newExpensePaidByEmoji = "🌍"
        newExpenseCurrency = "USD"
        showingAddExpense = false
    }
}
