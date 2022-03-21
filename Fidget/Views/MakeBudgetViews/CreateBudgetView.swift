//
//  CreateBugdetView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/5/22.
//

import SwiftUI

struct CreateBudgetView: View {
    @EnvironmentObject var homeViewModel : HomeViewModel
    @Binding var showBudgetNavigationViews : Bool
    @State private var budgetName : String = ""
    @State var incomeItems : [Budget.IncomeItem] = []
    
    func removeItem(at offsets: IndexSet) {
        incomeItems.remove(atOffsets: offsets)
    }
    
    var body: some View {
        
        VStack(){
            HStack{
                Text("Add Income")
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                    .kerning(AppFonts.titleKerning)
                Spacer()
            }
            .padding()
            Spacer()
            StandardTextField(label: "Budget Name", text: $budgetName)
                .padding(.horizontal)
            List{
                ForEach(0..<incomeItems.count, id: \.self) { i in
                    IncomeFieldView(incomeItem: self.$incomeItems[i])
                        .padding(.vertical)
                    
                }
                .onDelete(perform: removeItem)
                
                
                
            }
            .listStyle(.plain)
            .toolbar{
                EditButton()
            }
            
            Spacer()
            VStack(){
                StandardButton(label: "ADD SOURCE OF INCOME", function: {
                    incomeItems.append(Budget.IncomeItem())
                }).normalButtonLarge
                    .padding(.horizontal)
                
                
                NavigationLink(destination:
                                CreateBucketsView(showBudgetNavigationViews: $showBudgetNavigationViews,
                                                  incomeItems: $incomeItems,
                                                  budgetName: budgetName)
                                .environmentObject(homeViewModel))
                {
                    StandardButton(label: "CONTINUE").primaryButtonLabelLarge
                        .padding(.horizontal)
                }
                .isDetailLink(false)
                .navigationBarTitle("", displayMode: .inline)
                .disabled(incomeItems.isEmpty || budgetName.isEmpty || !self.incomeFieldsFilled())
            }
            .padding(.vertical)
        }
        
        
    }
    
    
    func incomeFieldsFilled() -> Bool{
        for item in incomeItems{
            let amount = item.amount
            let name = item.name
            
            if name.isEmpty || amount <= 0.0{
                return false
            }
        }
        return true
    }
}

/*
 struct CreateBugdetView_Previews: PreviewProvider {
 static var previews: some View {
 CreateBudgetView(showCreateBudgetNavigation: .constant(true))
 }
 }
 */


struct IncomeFieldView : View {
    @Binding var incomeItem : Budget.IncomeItem
    @State private var amountString : String = String()
    @State private var prevAmountString : String = String()
    var body: some View{
        
        
        VStack(){
            let infoTextColor = AppColor.normalMoreContrast
            VStack(alignment: .leading){
                Text("Source of Income Name")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(infoTextColor)
                HStack{
                    Image(systemName: "circle.fill")
                        .foregroundColor(AppColor.normal)
                    StandardTextField(label: "Ex: John's income", text: $incomeItem.name)
                }
            }
            VStack(alignment: .leading){
                Text("Income Amount")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(infoTextColor)
                HStack{
                    Image(systemName: "circle.fill")
                        .foregroundColor(AppColor.normal)
                    StandardTextField(label: "Ex: $2500.00", text: $amountString)
                        .keyboardType(.decimalPad)
                        .onChange(of: amountString, perform: { value in
                            self.formatUserChanges(value)
                        })
                }
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
                incomeItem.amount = Double(checkValue) ?? .zero
            }
            else{
                let decoded = FormatUtils.decodeFromNumberLegibleFormat(prevAmountString)
                amountString = decoded.isEmpty ? String() : FormatUtils.encodeToNumberLegibleFormat(decoded)
            }
        }
    }
}

