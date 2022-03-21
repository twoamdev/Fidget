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
    var body: some View {
        VStack{
            HStack{
                Text("Name the Budget")
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                    .kerning(AppFonts.titleKerning)
                Spacer()
            }
            .padding()
            
            VStack(alignment: .leading){
                Text("Budget Name")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(AppColor.normalMoreContrast)
                StandardTextField(label: "Budget Name", text: $budgetName)
                
            }
            .padding()
            
            Spacer()
            StandardButton(label: "CREATE BUDGET", function: {
                homeViewModel.saveNewBudget(budgetName, buckets, incomeItems, transactions)
                self.showBudgetNavigationViews.toggle()
            }).primaryButtonLarge
                .padding()
            
        }
    }
}

