import Foundation


fileprivate class BudgetItem {
    
    private var name: String;
    private var budgetedAmount: Double;
    private var actualAmount: Double;
    
    fileprivate init(name: String, budgetedAmount: Double, actualAmount: Double) {
        self.name = name
        self.budgetedAmount = budgetedAmount
        self.actualAmount = actualAmount
    }
    
    fileprivate func getName() -> String {
        return self.name
    }
    
    fileprivate func getBudgetedAmount() -> Double {
        return self.budgetedAmount
    }
    
    fileprivate func getActualAmount() -> Double {
        return self.actualAmount
    }
    
    fileprivate func updateName(name: String) {
        self.name = name
    }
    
    fileprivate func updateActualAmount(actualAmount: Double) {
        self.actualAmount += actualAmount
    }
    
    fileprivate func setBudgetedAmount(amount: Double) {
        self.budgetedAmount = amount
    }
    
    fileprivate func getDifference() -> Double{
        return self.budgetedAmount - self.actualAmount
    }
}

fileprivate class BudgetCategory {
    

//Responsibilities:
//Provide category‑level summaries
    
    private let categoryName: String;
    private var items: [String:BudgetItem] = [:];
    private var totalBudgeted: Double = 0;
    private var totalActual: Double = 0;
    
    fileprivate init(categoryName: String) {
        self.categoryName = categoryName
    }
    
    // ADD
    fileprivate func addItem(name: String, budgetedAmount: Double, actualAmount: Double) {
        // ADD Item to HashMap
        let item = BudgetItem(name: name, budgetedAmount: budgetedAmount, actualAmount: actualAmount);
        items[name] = item;
        
        // Update Total Budget
        self.totalBudgeted += budgetedAmount
        
        // Update Total Actual
        self.totalActual += actualAmount
    }
    
    // REMOVE
    fileprivate func removeItem(name: String) {
        // Update Total Budget and Actual
        self.totalActual -= items[name]?.getActualAmount() ?? 0
        self.totalBudgeted -= items[name]?.getBudgetedAmount() ?? 0
        
        // Remove from HashMap
        items.removeValue(forKey: name);
    }
    
    // UPDATES
    
    // Item Name -> check and make sure name isnt in hash first
    fileprivate func updateName(oldName: String, newName: String) -> Bool {
        // Check if an item with this name already exists in the category
        if self.items[newName] != nil {
            return false
        }
        // Ensure the old item exists
        guard let item = self.items.removeValue(forKey: oldName) else {
            return false
        }
        // Update the item's internal name and reinsert under the new key
        item.updateName(name: newName)
        self.items[newName] = item
        return true
    }
    
    // Item Budget
    fileprivate func updateBudget(name: String, newBudget: Double) -> Bool {
        guard let item = self.items[name] else { return false }
        // Adjust totals by removing the old budget and adding the new one
        self.totalBudgeted -= item.getBudgetedAmount()
        self.totalBudgeted += newBudget
        item.setBudgetedAmount(amount: newBudget)
        return true
    }
     
    // Item Actual
    fileprivate func updateActual(name: String, newActual: Double) -> Bool {
        guard let item = self.items[name] else { return false }
        self.totalActual -= item.getActualAmount()
        self.totalActual += newActual
        item.updateActualAmount(actualAmount: newActual)
        return true
    }
    
    // COMPUTE TOTALS
    fileprivate func getTotalBudgeted() -> Double {
        return self.totalBudgeted
    }
    
    fileprivate func getTotalActual() -> Double {
        return self.totalActual
    }

    fileprivate func getTotalDifference() -> Double {
        return self.totalBudgeted - self.totalActual
    }
    
    //Provide category‑level summaries?????

    
}

fileprivate class Transaction: Equatable {
    
    private var date: Date
    private var budgetName: String
    private var amount: Double
    private var category: BudgetCategory
    private var account: String
    
    init(date: Date, budgetName: String, amount: Double, category: BudgetCategory, account: String) {
        self.date = date
        self.budgetName = budgetName
        self.amount = amount
        self.category = category
        self.account = account
    }
    
    fileprivate func getDate() -> Date {
        return self.date
    }
    
    fileprivate func getAmount() -> Double {
        return self.amount
    }
    
    fileprivate func getCategory() -> BudgetCategory {
        return self.category
    }
    
    fileprivate func getAccount() -> String {
        return self.account
    }
    
    fileprivate func setDate(_ newDate: Date) {
        self.date = newDate
    }
    
    fileprivate func setAmount(_ newAmount: Double) {
        self.amount = newAmount
    }
    
    fileprivate func setCategory(_ newCategory: BudgetCategory) {
        self.category = newCategory
    }
    
    fileprivate func setAccount(_ newAccount: String) {
        self.account = newAccount
    }
    
    static func == (lhs: Transaction, rhs: Transaction) -> Bool {
        return lhs.getDate() == rhs.getDate()
        && lhs.getAmount() == rhs.getAmount()
        && lhs.getAccount() == rhs.getAccount()
        // For category comparison, use identity for now since BudgetCategory isn't Equatable
        && lhs.getCategory() === rhs.getCategory()
    }
}

fileprivate class TransactionLog {
    
    private var transactions: [Date: [Transaction]] = [:]
    
    fileprivate func addTransaction(newTransaction: Transaction) {
        if transactions[newTransaction.getDate()] != nil {
            transactions[newTransaction.getDate()]!.append(newTransaction)
        } else {
            transactions[newTransaction.getDate()] = [newTransaction]
        }
    }
    
    fileprivate func removeTransaction(deleteTransaction: Transaction) {
        let date = deleteTransaction.getDate()
        guard var list = transactions[date] else { return }
        if let idx = list.firstIndex(of: deleteTransaction) {
            list.remove(at: idx)
        }
        if list.isEmpty {
            transactions.removeValue(forKey: date)
        } else {
            transactions[date] = list
        }
    }
    
//Responsibilities:
//
//Filter by category, date, amount, BudgetName
//
//Feed data into the insights engine later
    
    
    
}

public class Budget {


//    Responsibilities:
//    Provide a full monthly snapshot
        // Where does my money Go?          | \
        // Spending Overview                -  > HASHMAPS
        // Budget vs Real (Categories)      | /
    
    private var income: BudgetCategory = BudgetCategory(categoryName: "Income")
    private var bills: BudgetCategory = BudgetCategory(categoryName: "Bills")
    private var subscriptions: BudgetCategory = BudgetCategory(categoryName: "Subscriptions")
    private var expenses: BudgetCategory = BudgetCategory(categoryName: "Expenses")
    private var savings: BudgetCategory = BudgetCategory(categoryName: "Savings")
    private var debts: BudgetCategory = BudgetCategory(categoryName: "Debts")
    
    public func getTotalBudget() -> Double {
        return self.income.getTotalBudgeted() - self.bills.getTotalBudgeted() - self.subscriptions.getTotalBudgeted() + self.expenses.getTotalBudgeted() - self.savings.getTotalBudgeted() - self.debts.getTotalBudgeted()
    }
    
    public func getTotalActual() -> Double {
        return self.income.getTotalActual() - self.bills.getTotalActual() - self.subscriptions.getTotalActual() + self.expenses.getTotalActual() - self.savings.getTotalActual() - self.debts.getTotalActual()
    }
    
    public func getLeftToBudget() -> Double {
        return self.getTotalBudget() - self.getTotalActual()
    }
    
    public func getLeftToSpend() -> Double {
        return self.getTotalActual() - self.getTotalBudget()
    }
    
    public func getTotalIncome() -> Double {
        return self.income.getTotalActual()
    }
    
    public func getTotalExpenses() -> Double {
        return self.expenses.getTotalActual() + self.bills.getTotalActual() + self.subscriptions.getTotalActual() +
        self.debts.getTotalActual() + self.savings.getTotalActual()
    }
    
    
}

