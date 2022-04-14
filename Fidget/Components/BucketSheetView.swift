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
    @EnvironmentObject var bucketSheetVM : BucketSheetViewModel
    @Binding var showSheet : Bool

    
    var body: some View {
        ZStack{
            AppColor.bg
                .onTapGesture {self.dismissFocusOnAll()}
            
            VStack(){
                progress
                transactionBody
                StandardButton(label: "DONE", function: {
                    UXUtils.hapticButtonPress()
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
                    Text("Bucket Name")
                        .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                        .foregroundColor(infoTextColor)
                    TextField("Name", text: $bucketSheetVM.bucket.name)
                        .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                        .foregroundColor(AppColor.fg)
                        .accentColor(AppColor.primary)
                        .onChange(of: bucketSheetVM.bucket.name, perform: { value in
                            if value.count > FormatUtils.maxBucketNameLimit{
                                bucketSheetVM.bucket.name = String(value.prefix(FormatUtils.maxBucketNameLimit))
                            }
                            
                            self.bucketSheetVM.bucketChanged = true
                        })
                    Rectangle()
                         .frame(height: 1)
                         .foregroundColor(AppColor.fg)
                         .padding(.trailing, 16)
                }
                Spacer()
            }
            .padding()
            .padding(.vertical)
            
            VStack{
                HStack{
                    VStack(alignment: .leading){
                        Text("Spend Limit")
                            .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                            .foregroundColor(infoTextColor)
                        StandardTextField(label: "Spend Limit", text: $bucketSheetVM.spendCapacityString)
                            .keyboardType(.decimalPad)
                            .onChange(of: bucketSheetVM.spendCapacityString, perform: { value in
                                let helper = NumberFormatterHelper(value, bucketSheetVM.spendCapacityString, bucketSheetVM.prevSpendCapacityString, bucketSheetVM.bucket.capacity)
                                FormatUtils.formatNumberStringForUserAndValue(helper)
                                bucketSheetVM.spendCapacityString = helper.displayText
                                bucketSheetVM.prevSpendCapacityString = helper.prevDisplayText
                                bucketSheetVM.bucket.capacity = helper.numberValue
                                
                                self.bucketSheetVM.bucketChanged = true
                            })
                    }
                    
                    VStack(alignment: .trailing, spacing: 1.0){
                        Text("Rollover")
                            .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                            .foregroundColor(AppColor.normalMoreContrast)
                        Toggle("", isOn: $bucketSheetVM.bucket.rolloverEnabled)
                                .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.inputFieldSize))
                                .tint(AppColor.primary)
                                .onChange(of: bucketSheetVM.bucket.rolloverEnabled, perform: { _ in
                                    self.bucketSheetVM.bucketChanged = true
                                })
                    }
                }
                
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
               
                ForEach((0..<bucketSheetVM.transactions.count).reversed() , id: \.self) { i in
                    TransactionListEditItem(transaction: $bucketSheetVM.transactions[i], bucketName: $bucketSheetVM.bucket.name,
                                            function: {
                        removeItem(at: IndexSet(integer: i), removeIndex: i)
                        self.bucketSheetVM.transactionsChanged = true
                    })
                        .environmentObject(transactionViewModel)
                }
                
            }
            .listStyle(.plain)
        }
    }
    
    func removeItem(at offsets: IndexSet, removeIndex : Int) {
        bucketSheetVM.removeTransaction(offsets: offsets, index: removeIndex)
    }
}



