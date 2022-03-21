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
        VStack(){
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
                        self.formatSpendValueChanges(value)
                    })
            }
            VStack(alignment: .leading){
                Text("Spend Limit")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(infoTextColor)
                StandardTextField(label: "Ex: $800", text: $spendCapacityString)
                    .keyboardType(.decimalPad)
                    .onChange(of: spendCapacityString, perform: { value in
                        self.formatCapacityValueChanges(value)
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
    
    private func formatSpendValueChanges(_ value : String){
        if !value.isEmpty{
            let checkValue = FormatUtils.decodeFromNumberLegibleFormat(value)
            let formatIsCorrect = FormatUtils.validateNumberFormat(checkValue)
            
            if formatIsCorrect{
                spendValueString = checkValue.isEmpty ? String() : FormatUtils.encodeToNumberLegibleFormat(checkValue)
                prevSpendValueString = spendValueString
                spendValue = Double(checkValue) ?? .zero
            }
            else{
                let decoded = FormatUtils.decodeFromNumberLegibleFormat(prevSpendValueString)
                spendValueString = decoded.isEmpty ? String() : FormatUtils.encodeToNumberLegibleFormat(decoded)
            }
        }
    }
    
    private func formatCapacityValueChanges(_ value : String){
        if !value.isEmpty{
            let checkValue = FormatUtils.decodeFromNumberLegibleFormat(value)
            let formatIsCorrect = FormatUtils.validateNumberFormat(checkValue)
            
            if formatIsCorrect{
                spendCapacityString = checkValue.isEmpty ? String() : FormatUtils.encodeToNumberLegibleFormat(checkValue)
                prevSpendCapacityString = spendCapacityString
                spendCapacity = Double(checkValue) ?? .zero
            }
            else{
                let decoded = FormatUtils.decodeFromNumberLegibleFormat(prevSpendCapacityString)
                spendCapacityString = decoded.isEmpty ? String() : FormatUtils.encodeToNumberLegibleFormat(decoded)
            }
        }
    }
}

