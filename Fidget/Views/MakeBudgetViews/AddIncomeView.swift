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
        ZStack{
            AppColor.bg
                .onTapGesture {
                    self.dismissFocusOnAll()
                }
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
                    
                    
                    StandardButton(label: "ADD SOURCE OF INCOME", function: {
                        let newIncomeItem = Budget.IncomeItem(incomeName, incomeAmount)
                        incomeItems.append(newIncomeItem)
                        showAddIncomeView.toggle()
                    }).primaryButtonLarge
                        .padding(.horizontal)
                        .disabled(incomeName.isEmpty || incomeAmount == .zero)
                    
                }
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
                        let helper = NumberFormatterHelper(value, amountString, prevAmountString, incomeAmount)
                        FormatUtils.formatNumberStringForUserAndValue(helper)
                        amountString = helper.displayText
                        prevAmountString = helper.prevDisplayText
                        incomeAmount = helper.numberValue
                    })
            }
        }
    }
}

