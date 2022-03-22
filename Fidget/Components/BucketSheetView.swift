//
//  BucketSheetView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/20/22.
//

import SwiftUI

struct BucketSheetView: View {
    let infoTextColor = AppColor.normalMoreContrast
    @EnvironmentObject var homeViewModel : HomeViewModel
    @EnvironmentObject var transactionViewModel : TransactionViewModel
    @State var bucket: Bucket
    var bucketBalance : Double
    @Binding var showSheet : Bool
    @State var enableEdits = false
    @State var confirmChanges = false
    
    @State var name : String
    @State var spendValue : Double = 0.0
    @State var spendValueString : String
    @State var prevSpendValueString = String()
    
    @State var spendCapacity : Double
    @State var spendCapacityString : String
    @State var prevSpendCapacityString = String()
    
    @State var rolloverEnabled : Bool
    
    init(bucket : Bucket , balance : Double, showSheet : Binding<Bool>){
        self.name = bucket.name
        self._showSheet = showSheet
        self.spendCapacity = bucket.capacity
        self.rolloverEnabled = bucket.rolloverEnabled
        self.bucket = bucket
        self.bucketBalance = balance
        self.spendValueString = FormatUtils.encodeToNumberLegibleFormat(String(balance), killDecimal: true)
        self.spendCapacityString = FormatUtils.encodeToNumberLegibleFormat(String(bucket.capacity), killDecimal: true)
    }
    
    
    var body: some View {
        ZStack{
            AppColor.bg
                .onTapGesture {self.dismissFocusOnAll()}
            
            VStack(){
                progress
                transactionBody
                StandardButton(label: "DONE", function: {
                    showSheet.toggle()
                }).normalButtonLarge
                    .padding()
            }
        }
    }
    
    var progress : some View {
        VStack{
            HStack{
                VStack(alignment: .leading, spacing: 0){
                    TextField("Bucket Name", text: $name)
                        .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                        .foregroundColor(AppColor.fg)
                        .accentColor(AppColor.primary)
                        .disabled(!enableEdits)
                    Rectangle()
                         .frame(height: 1)
                         .foregroundColor(AppColor.fg.opacity(enableEdits ? 1.0 : 0.0))
                         .padding(.trailing, 16)
                }
                Spacer()
                Image(systemName: enableEdits ? "pencil.circle.fill" : "pencil.circle")
                    .resizable()
                    .frame(width: AppFonts.titleFieldSize, height: AppFonts.titleFieldSize)
                    .foregroundColor(AppColor.primary)
                    .onTapGesture {
                        enableEdits.toggle()
                        if enableEdits == false{
                            let nameChanged : Bool = name == bucket.name ? false : true
                            let spendCapacityChanged : Bool = spendCapacity == bucket.capacity ? false : true
                            let rolloverChanged : Bool = rolloverEnabled == bucket.rolloverEnabled ? false : true
                            if spendCapacityChanged || rolloverChanged || nameChanged{
                                confirmChanges.toggle()
                            }
                        }
                    }
                    .confirmationDialog("Save Changes", isPresented: $confirmChanges){
                        StandardButton(label: "Save Changes", function: {
                            bucket.name = name
                            bucket.capacity = self.spendCapacity
                            bucket.rolloverEnabled = self.rolloverEnabled
                            homeViewModel.updateExistingBucketInBudget(bucket)
                        })
                        Button("Cancel", role: .cancel) {
                            self.name = bucket.name
                            self.spendCapacity = bucket.capacity
                            self.rolloverEnabled = bucket.rolloverEnabled
                            self.spendCapacityString = FormatUtils.encodeToNumberLegibleFormat(String(bucket.capacity), killDecimal: true)
                        }
                    } message : {
                        Text("Do you want to save your changes?")
                    }
                
            }
            .padding()
            .padding(.vertical)
            
            VStack{
                
                HStack{
                    
                    VStack(alignment: .leading){
                        Text("Spend Limit")
                            .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                            .foregroundColor(infoTextColor)
                        StandardTextField(locked: !enableEdits, label: "Spend Limit", text: $spendCapacityString)
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
                        Text("Rollover")
                            .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                            .foregroundColor(AppColor.normalMoreContrast)
                            Toggle("", isOn: $rolloverEnabled)
                                .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.inputFieldSize))
                                .tint(AppColor.primary)
                                .disabled(!enableEdits)
                    }
                }
                /*
                
                HStack{
                    VStack(alignment: .leading){
                        Text("Rollover Amount")
                            .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                            .foregroundColor(infoTextColor)
                        StandardTextField(label: "Rollover Amount", text: .constant("$000.00"))
                        .disabled(true)
                    }
                    
                    
                }*/
                
            }.padding(.horizontal)
            
        }
    }
    
    var transactionBody : some View {
        VStack(){
            HStack{
                Text("Transactions")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(infoTextColor)
                Spacer()
            }
            .padding(.horizontal)
            
            List{
                let transactions = homeViewModel.transactionsInBucket(bucket.id)
                let count = transactions.count
                ForEach((0..<count).reversed() , id: \.self) { i in
                    let trans = transactions[i]
                    let displayName = transactionViewModel.transactionOwnerDisplayName(trans)
                    TransactionListElementView(transaction: trans, bucketName: trans.merchantName, ownerDisplayName: displayName)
                }
                .onDelete(perform:{ offsets in
                    homeViewModel.removeTransactionFromBudget(offsets, bucket.id)
                })
            }
            .listStyle(.plain)
        }
    }
}



