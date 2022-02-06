//
//  CreateBugdetView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/5/22.
//

import SwiftUI

struct CreateBudgetView: View {
    @EnvironmentObject var bucketsViewModel : BucketsViewModel
    @State private var name : String = ""
    @State private var income : String = ""
    @State var incomeItems : [IncomeItem] = [IncomeItem(),IncomeItem()]
    var body: some View {
        VStack(){
    
            Text("Enter income streams per month")
            Spacer()
            ScrollView(){
                ForEach(incomeItems, id: \.self) { item in
                    IncomeField(name: item.name, amount: item.amount)
                }
            }
            Spacer()
            Button(action: {
                incomeItems.append(IncomeItem())
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
        }
    }
}

struct CreateBugdetView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBudgetView()
    }
}

struct IncomeField : View {
    @State var name : String = ""
    @State var amount : String = ""
    
    var body: some View{
        HStack(){
            TextFieldView(label: "Income Source", userInput: $name, errorMessage: "").standardTextField
            TextFieldView(label: "Amount", userInput: $amount, errorMessage: "").standardTextField
        }
        .padding(.horizontal)
    }
}

struct IncomeItem : Identifiable, Hashable{
    var id  = UUID()
    var name : String
    var amount : String
    
    init(){
        self.name = ""
        self.amount = ""
    }
    
    
    
}
