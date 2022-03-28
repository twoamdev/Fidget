//
//  FinalizeBudgetView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/21/22.
//

import SwiftUI

struct FinalizeBudgetView: View {
    @EnvironmentObject var homeViewModel : HomeViewModel
    @Binding var showBudgetNavigationViews : Bool
    @Binding var incomeItems : [Budget.IncomeItem]
    @Binding var buckets : [Bucket]
    @Binding var transactions : [Transaction]
    @State var budgetName = String()
    
    @State var prevBudgetName = String()
    @State var greenCheck = false
    
    var body: some View {
        VStack{
            HStack{
                Text("Name the Budget")
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                    .kerning(AppFonts.titleKerning)
                Spacer()
            }
            .padding()
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 0){
                Text("Budget Name")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(AppColor.normalMoreContrast)
                
                StandardTextField(label: "Budget Name", text: $budgetName)
                    .onChange(of: budgetName, perform: { value in
                        greenCheck = value.isEmpty ? false : true
                        
                        let isValid = ValidationUtils().validateName(value) || value.isEmpty
                        if !isValid {
                            budgetName = prevBudgetName
                        }
                        else{
                            prevBudgetName = budgetName
                        }
                        
                    })
                
                StandardUserTextHelper(message: "Only letters allowed.", indicator: $greenCheck)
                    .padding(.vertical)
                
            }
            .padding()
            
            Spacer()
            if(budgetName.isEmpty){
                StandardButton(lockedStyle: true, label: "CREATE BUDGET", function: {}).primaryButtonLarge
                    .padding()
            }
            else{
                StandardButton(label: "CREATE BUDGET", function: {
                    homeViewModel.saveNewBudget(budgetName, buckets, incomeItems, transactions)
                    self.showBudgetNavigationViews.toggle()
                }).primaryButtonLarge
                    .padding()
            }
        }
    }
}

