import SwiftUI

struct ExpenseSliceData: Identifiable {
    let id = UUID()
    let category: Expense.ExpenseCategory
    let amount: Double
    let startAngle: Double
    let endAngle: Double
}

struct ExpensePieChart: View {
    let expenses: [(category: Expense.ExpenseCategory, amount: Double)]
    let total: Double

    private var slices: [ExpenseSliceData] {
        var result: [ExpenseSliceData] = []
        var currentAngle: Double = 0
        for expense in expenses {
            let percentage = total > 0 ? expense.amount / total : 0
            let sliceAngle = 360 * percentage
            result.append(ExpenseSliceData(
                category: expense.category,
                amount: expense.amount,
                startAngle: currentAngle,
                endAngle: currentAngle + sliceAngle
            ))
            currentAngle += sliceAngle
        }
        return result
    }

    var body: some View {
        ZStack {
            ForEach(slices) { slice in
                PieSlice(startAngle: slice.startAngle, endAngle: slice.endAngle)
                    .fill(Color(hex: slice.category.colorHex))
            }
        }
        .frame(width: 120, height: 120)
    }
}

struct PieSlice: Shape {
    var startAngle: Double
    var endAngle: Double

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = Angle(degrees: startAngle - 90)
        let end = Angle(degrees: endAngle - 90)
        
        path.move(to: center)
        path.addArc(
            center: center,
            radius: radius,
            startAngle: start,
            endAngle: end,
            clockwise: false
        )
        path.closeSubpath()
        
        return path
    }
}
