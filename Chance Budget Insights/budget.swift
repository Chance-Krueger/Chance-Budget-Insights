//
//  budget.swift
//  Chance Budget Insights
//
//  Created by Chance Krueger on 1/27/26.
//

public enum BudgetCategory {
    case bills
    case income
    case expenses
    case savings
    case debts
    case subscriptions
}

fileprivate struct Income {
    // SOURCE -> DESCRIPTION (UA, WORK, PERSONAL BIZ, ETC.)
    // PAYDAY -> DAY OF PAY
    // EXPECTED
    // REAL
    // DEPOSITED IN -> WHICH ACCT
}

fileprivate struct formMap {
    // MAKE THIS AN ARRAY OF SOME SORT TO GET RID OF ANY, WILL MAKE EASIER IN LONG RUN
    
    private var map : [String: Double] = [:]
    
    init(budget: Double, real: Double) {
        
        let difference : Double = budget - real
    
        self.map = ["Budget": budget, "Real": real, "Difference": difference]
    }
    
    fileprivate func getBudget() -> Double {
        return map["Budget"] ?? 0
    }
    
    fileprivate func getReal() -> Double {
        return map["Real"] ?? 0
    }
    
    fileprivate func getDifference() -> Double {
        return map["Difference"] ?? 0
    }
    
    fileprivate mutating func changeData(newBudget: Double, newReal: Double, newDifference: Double) -> Bool {
        
        self.map["Budget"] = newBudget
        self.map["Real"] = newReal
        self.map["Difference"] = newDifference
        return true
    }
}

fileprivate class BudgetTracker {
    
    private var map: [String: formMap] = [:]
    
    fileprivate func getMap() -> [String: formMap] {
        return self.map
    }
    
    fileprivate func addDescriptionToMap(description: String, budget: Double, real: Double) {
        self.map[description] = formMap(budget: budget, real: real)
    }
    
    fileprivate func removeDescriptionFromMap(description: String) {
        self.map.removeValue(forKey: description)
    }
    
    fileprivate func changeDataWithDescription(description: String, newBudget: Double, newReal: Double, newDifference: Double) -> Bool {
        guard var entry = self.map[description] else { return false }
        if entry.changeData(newBudget: newBudget, newReal: newReal, newDifference: newDifference) {
            self.map[description] = entry
            return true
        }
        return false
    }
    
    fileprivate func changeDescription(oldDescription: String, newDescription: String) {
        guard let value = self.map[oldDescription] else { return }
        self.map[newDescription] = value
        self.map.removeValue(forKey: oldDescription)
    }
}

struct Budgeter {
    
    private var income: BudgetTracker = BudgetTracker() // FIX THIS IS NOT SAME
    private var bills: BudgetTracker = BudgetTracker()
    private var subscriptions: BudgetTracker = BudgetTracker()
    private var expenses: BudgetTracker = BudgetTracker()
    private var savings: BudgetTracker = BudgetTracker()
    private var debts: BudgetTracker = BudgetTracker()
    
//    @available(*, deprecated, message: "Use getCertainBudget(category:) instead")
//    public func getCertianBudget(category: BudgetCategory) -> Double {
//        getCertainBudget(category: category)
//    }
    
    public func getTotalBudget() -> Double {
        return getTotalExpensesBudget() + getTotalBillsBudget() + getTotalDebtsBudget()
            + getTotalSubscriptionsBudget() + getTotalSavingsBudget() + getTotalIncomeBudget()
    }
    
    public func getCertainBudget(category: BudgetCategory) -> Double {
        switch category {
        case .bills:
            return getTotalBillsBudget()
        case .income:
            return getTotalIncomeBudget()
        case .expenses:
            return getTotalExpensesBudget()
        case .savings:
            return getTotalSavingsBudget()
        case .debts:
            return getTotalDebtsBudget()
        case .subscriptions:
            return getTotalSubscriptionsBudget()
        }
    }
    
    public func getTotalRealSpending() -> Double {
        return getTotalExpensesRealSpending() + getTotalBillsRealSpending() + getTotalDebtsRealSpending()
        + getTotalSubscriptionsRealSpending() + getTotalSavingsRealSpending() + getTotalIncomeRealSpending()
    }
    
    public func getCertianRealSpending(category: BudgetCategory) -> Double {
        switch category {
        case .bills:
            return getTotalBillsRealSpending()
        case .income:
            return getTotalIncomeRealSpending()
        case .expenses:
            return getTotalExpensesRealSpending()
        case .savings:
            return getTotalSavingsRealSpending()
        case .debts:
            return getTotalDebtsRealSpending()
        case .subscriptions:
            return getTotalSubscriptionsRealSpending()
        }
    }

    private func getTotalBillsBudget() -> Double {
        bills.getMap().values.reduce(0) { partial, entry in
            partial + entry.getBudget()
        }
    }
    
    private func getTotalIncomeBudget() -> Double {
        income.getMap().values.reduce(0) { partial, entry in
            partial + entry.getBudget()
        }
    }
    
    private func getTotalExpensesBudget() -> Double {
        expenses.getMap().values.reduce(0) { partial, entry in
            partial + entry.getBudget()
        }
    }
    
    private func getTotalSavingsBudget() -> Double {
        savings.getMap().values.reduce(0) { partial, entry in
            partial + entry.getBudget()
        }
    }
    
    private func getTotalDebtsBudget() -> Double {
        debts.getMap().values.reduce(0) { partial, entry in
            partial + entry.getBudget()
        }
    }
    
    private func getTotalSubscriptionsBudget() -> Double {
        subscriptions.getMap().values.reduce(0) { partial, entry in
            partial + entry.getBudget()
        }
    }
    
    private func getTotalBillsRealSpending() -> Double {
        bills.getMap().values.reduce(0) { partial, entry in
            partial + entry.getReal()
        }
    }

    private func getTotalIncomeRealSpending() -> Double {
        income.getMap().values.reduce(0) { partial, entry in
            partial + entry.getReal()
        }
    }

    private func getTotalExpensesRealSpending() -> Double {
        expenses.getMap().values.reduce(0) { partial, entry in
            partial + entry.getReal()
        }
    }

    private func getTotalSavingsRealSpending() -> Double {
        savings.getMap().values.reduce(0) { partial, entry in
            partial + entry.getReal()
        }
    }

    private func getTotalDebtsRealSpending() -> Double {
        debts.getMap().values.reduce(0) { partial, entry in
            partial + entry.getReal()
        }
    }

    private func getTotalSubscriptionsRealSpending() -> Double {
        subscriptions.getMap().values.reduce(0) { partial, entry in
            partial + entry.getReal()
        }
    }
}
