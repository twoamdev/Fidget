//
//  AddBucketView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/6/22.
//

import SwiftUI

struct AddBucketView: View {
    @Binding var showAddBucketView : Bool
    @Binding var buckets : [Bucket]
    @Binding var transactions : [Transaction]
    
    @State var name : String = ""
    @State var spendValue : Double = 0.0
    @State var spendValueString = String()
    @State var prevSpendValueString = String()
    
    @State var spendCapacity : Double = 0.0
    @State var spendCapacityString = String()
    @State var prevSpendCapacityString = String()
    
    @State var rolloverEnabled : Bool = false
    
    var body: some View {
        ZStack(){
            AppColor.bg
                .onTapGesture {
                    self.dismissFocusOnAll()
                }
            VStack{
                
                HStack{
                    Text("Add Bucket")
                        .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                        .kerning(AppFonts.titleKerning)
                    Spacer()
                }
                .padding()
                
                bucketField
                    .padding()
                
                
                VStack(){
                    
                    StandardButton(label: "CANCEL", function: {
                        showAddBucketView.toggle()
                    }).normalButtonLarge
                        .padding(.horizontal)
                    
                    
                    StandardButton(label: "CREATE BUCKET", function: {
                        let newBucket = Bucket(name: name, capacity: spendCapacity, rollover: rolloverEnabled)
                        buckets.append(newBucket)
                        if spendValue != .zero {
                            let newTransaction = BudgetDataUtils().createInitialTransaction(newBucket, spendValue)
                            transactions.append(newTransaction)
                        }
                        showAddBucketView.toggle()
                    }).primaryButtonLarge
                        .padding(.horizontal)
                        .disabled(name.isEmpty || spendCapacity <= .zero)
                    
                }
            }
        }
        
    }
    
    var bucketField : some View{
        VStack{
            let infoTextColor = AppColor.normalMoreContrast
            VStack(alignment: .leading){
                Text("Bucket Name")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(infoTextColor)
                StandardTextField(label: "Ex: Groceries", text: $name)
            }
            VStack(alignment: .leading){
                Text("Money Spent This Month")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(infoTextColor)
                StandardTextField(label: "Ex: $23.05", text: $spendValueString)
                    .keyboardType(.decimalPad)
                    .onChange(of: spendValueString, perform: { value in
                        let helper = NumberFormatterHelper(value, spendValueString, prevSpendValueString, spendValue)
                        FormatUtils.formatNumberStringForUserAndValue(helper)
                        spendValueString = helper.displayText
                        prevSpendValueString = helper.prevDisplayText
                        spendValue = helper.numberValue
                    })
            }
            VStack(alignment: .leading){
                Text("Spend Limit")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(infoTextColor)
                StandardTextField(label: "Ex: $800", text: $spendCapacityString)
                    .keyboardType(.decimalPad)
                    .onChange(of: spendCapacityString, perform: { value in
                        let helper = NumberFormatterHelper(value, spendCapacityString, prevSpendCapacityString, spendCapacity)
                        FormatUtils.formatNumberStringForUserAndValue(helper)
                        spendCapacityString = helper.displayText
                        prevSpendCapacityString = helper.prevDisplayText
                        spendCapacity = helper.numberValue
                    })
            }
            
            
            VStack(alignment: .trailing, spacing: 1.0){
                Text("Rollover Balance Each Month")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(AppColor.normalMoreContrast)
                Toggle("", isOn: $rolloverEnabled)
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.inputFieldSize))
                    .tint(AppColor.primary)
            }
        }
    }
}


extension View {
    func dismissFocusOnAll() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

