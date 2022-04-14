//
//  ManageBudgetsViewModel.swift
//  Fidget
//
//  Created by Ben Nelson on 4/2/22.
//

import SwiftUI

class ManageBudgetsViewModel : ObservableObject {
    @Published var currentBudgetIsSelected : Bool = false
    @Published var otherBudgetSelectionIndex : Int = -1
    private let indexDefault : Int = -1
    
    
    
    func toggleOtherBudgetSelections(_ index : Int){
        if self.otherBudgetSelectionIndex == index{
            self.otherBudgetSelectionIndex = self.indexDefault
        }
        else{
            self.otherBudgetSelectionIndex = index
        }
    }
    
    func getOtherSelectedBudgetIndex() -> Int{
        return self.otherBudgetSelectionIndex
    }
    
    func noBudgetsAreSelected(){
        self.deselectAllOtherBudgets()
        self.currentBudgetIsSelected = false
    }
    
    
    func deselectAllOtherBudgets(){
        self.otherBudgetSelectionIndex = self.indexDefault
    }
    
    func isAnOtherBudgetSelected() -> Bool{
        return self.otherBudgetSelectionIndex == self.indexDefault ? false : true
    }
     
    
    func shareBudgetIsValid() -> Bool{
        return self.currentBudgetIsSelected || self.isAnOtherBudgetSelected()
    }
    
    func setToCurrentBudgetIsValid() -> Bool{
        return self.isAnOtherBudgetSelected() && !self.currentBudgetIsSelected
    }
    
}

