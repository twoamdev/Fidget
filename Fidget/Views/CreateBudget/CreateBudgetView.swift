//
//  CreateBugdetView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/5/22.
//

import SwiftUI

struct CreateBudgetView: View {
    @EnvironmentObject var bucketsViewModel : BucketsViewModel
    @Binding var showCreateBudgetNavigation : Bool
    @State private var budgetName : String = ""
    @State var incomeItems : [Budget.IncomeItem] = []
    
    func removeItem(at offsets: IndexSet) {
        incomeItems.remove(atOffsets: offsets)
    }
    
    var body: some View {
    
        VStack(){
    
            Text("Enter income streams per month")
            Spacer()
            TextFieldView(label: "Budget Name", userInput: $budgetName, errorMessage: "").standardTextField
                .padding()
            List{
                ForEach(0..<incomeItems.count, id: \.self) { i in
                    IncomeFieldView(incomeItem: self.$incomeItems[i])
                    
                }
                .onDelete(perform: removeItem)
                .animation(.easeInOut)
                
            }
            .toolbar{
                EditButton()
            }
            Spacer()
            HStack(){
                Spacer()
                Spacer()
                Button(action: {
                    incomeItems.append(Budget.IncomeItem())
                } ){
                Image(systemName: "plus")
                    .resizable()
                    .padding(6)
                    .frame(width: 60, height: 60)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .padding()
                }
                NavigationLink(destination: CreateBudgetBucketsView(showCreateBudgetNavigation : $showCreateBudgetNavigation, incomeItems: $incomeItems, budgetName: budgetName).environmentObject(bucketsViewModel))
                {
                Image(systemName: "chevron.right")
                    //.resizable()
                    .padding(6)
                    .frame(width: 40, height: 40)
                    .background(Color.green)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .padding()
                }
                
                Spacer()
            }
        }
        
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
    
    
    var body: some View{
        HStack(){
            TextFieldView(label: "Income Source", userInput: $incomeItem.name, errorMessage: "").standardTextField
            TextFieldView(label: "Amount", userInput: $incomeItem.amount, errorMessage: "").standardTextField
        }
        .padding(.horizontal)
    }
}

