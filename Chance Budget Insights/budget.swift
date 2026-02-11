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
    
    fileprivate init(categoryName: String, totalBudgeted: Double, totalActual: Double) {
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

fileprivate class Transaction {
    
}

fileprivate class TransactionLog {
    
}

public class Budget {
    
}

