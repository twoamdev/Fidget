//
//  EditBudgetViewModel.swift
//  Fidget
//
//  Created by Ben Nelson on 4/4/22.
//

import SwiftUI

class EditBudgetViewModel : ObservableObject {
    
    @Published var budgetName = String()
    @Published var incomeItems : [Budget.IncomeItem] = []
    @Published var isPrivate : Bool = false
    private var isCurrentBudget : Bool = false
    private var otherBudgetIndex : Int = -1
    
    func updateEditParameters(_ budget : Budget, isCurrentBudget : Bool = false, otherBudgetIndex : Int = -1){
        self.budgetName = budget.name
        self.incomeItems = budget.incomes
        self.isPrivate = budget.linkedUserIds.count < 2 ? true : false
        self.isCurrentBudget = isCurrentBudget
        self.otherBudgetIndex = otherBudgetIndex
    }
    
    func editIsCurrentBudget() -> Bool {
        return self.isCurrentBudget
    }
    
    func editIsOtherBudget() -> (Bool , Int) {
        let value = self.otherBudgetIndex > -1 ? true : false
        return (value, self.otherBudgetIndex)
    }
}
