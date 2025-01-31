//
//  CreateBugdetView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/5/22.
//

import SwiftUI

struct CreateIncomeView: View {
    @EnvironmentObject var homeViewModel : HomeViewModel
    @Binding var showBudgetNavigationViews : Bool
    @State var showAddIncomeView : Bool = false
    @State var incomeItems : [Budget.IncomeItem] = []
    @State private var showContinueAlert = false
    
    
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
            
            if incomeItems.count == .zero{
                Text("No Income Listed Yet.")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.inputFieldSize))
            }
            else{
                List{
                    ForEach(0..<incomeItems.count, id: \.self) { i in
                        IncomeItemMiniView(incomeItem: self.$incomeItems[i], onDelete: {
                            removeItem(at: IndexSet(integer: i))
                        })
                            .padding(.vertical)
                        
                    }
                }
                .listStyle(.plain)
            }
            
            Spacer()
            VStack(){
                
                StandardButton(label: "ADD SOURCE OF INCOME", function: {
                    showAddIncomeView.toggle()
                }).normalButtonLarge
                    .padding(.horizontal)
                    .sheet(isPresented: $showAddIncomeView) {
                        AddIncomeView(showAddIncomeView: $showAddIncomeView , incomeItems: $incomeItems)
                    }
                
                
                
                if(incomeItems.isEmpty || !self.incomeFieldsFilled()){
                    StandardButton(lockedStyle: true, label: "CONTINUE").primaryButtonLabelLarge
                        .padding(.horizontal)
                }
                else{
                    NavigationLink(destination:
                                    CreateBucketsView(showBudgetNavigationViews: $showBudgetNavigationViews,
                                                      incomeItems: $incomeItems)
                                    .environmentObject(homeViewModel))
                    {
                        StandardButton(label: "CONTINUE").primaryButtonLabelLarge
                            .padding(.horizontal)
                    }
                    .isDetailLink(false)
                    .navigationBarTitle("", displayMode: .inline)
                }
                
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



