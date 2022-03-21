//
//  AddBudgetIncomeView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/21/22.
//

import SwiftUI

struct AddIncomeView: View {
    @Binding var showAddIncomeView : Bool
    @Binding var incomeItems : [Budget.IncomeItem]
    
    @State private var amountString : String = String()
    @State private var prevAmountString : String = String()
    @State private var incomeName = String()
    @State private var incomeAmount : Double = 0.0
    
    var body: some View {
        VStack(){
            HStack{
                Text("Add Source of Income")
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                    .kerning(AppFonts.titleKerning)
                Spacer()
            }
            .padding()
            
            incomeField
                .padding()
            
            
            VStack(){
                
                StandardButton(label: "CANCEL", function: {
                    showAddIncomeView.toggle()
                }).normalButtonLarge
                    .padding(.horizontal)
                
                
                StandardButton(label: "ADD AS SOURCE OF INCOME", function: {
                    let newIncomeItem = Budget.IncomeItem(incomeName, incomeAmount)
                    incomeItems.append(newIncomeItem)
                    showAddIncomeView.toggle()
                }).primaryButtonLarge
                    .padding(.horizontal)
                    .disabled(incomeName.isEmpty || incomeAmount == .zero)
                
            }
        }
    }
    
    private var incomeField : some View{
        VStack{
            let infoTextColor = AppColor.normalMoreContrast
            VStack(alignment: .leading){
                Text("Source of Income")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(infoTextColor)
                StandardTextField(label: "Ex: John's Income", text: $incomeName)
            }
            VStack(alignment: .leading){
                Text("Income Amount Per Month")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(infoTextColor)
                StandardTextField(label: "Ex: $2000", text: $amountString)
                    .keyboardType(.decimalPad)
                    .onChange(of: amountString, perform: { value in
                        self.formatUserChanges(value)
                    })
            }
        }
    }
    
    private func formatUserChanges(_ value : String){
        if !value.isEmpty{
            let checkValue = FormatUtils.decodeFromNumberLegibleFormat(value)
            let formatIsCorrect = FormatUtils.validateNumberFormat(checkValue)
            
            if formatIsCorrect{
                amountString = checkValue.isEmpty ? String() : FormatUtils.encodeToNumberLegibleFormat(checkValue)
                prevAmountString = amountString
                incomeAmount = Double(checkValue) ?? .zero
            }
            else{
                let decoded = FormatUtils.decodeFromNumberLegibleFormat(prevAmountString)
                amountString = decoded.isEmpty ? String() : FormatUtils.encodeToNumberLegibleFormat(decoded)
            }
        }
    }
}
