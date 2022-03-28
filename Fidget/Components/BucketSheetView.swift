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
                    TextField("Bucket Name", text: $bucketSheetVM.name)
                        .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                        .foregroundColor(AppColor.fg)
                        .accentColor(AppColor.primary)
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
                                let helper = NumberFormatterHelper(value, bucketSheetVM.spendCapacityString, bucketSheetVM.prevSpendCapacityString, bucketSheetVM.spendCapacity)
                                FormatUtils.formatNumberStringForUserAndValue(helper)
                                bucketSheetVM.spendCapacityString = helper.displayText
                                bucketSheetVM.prevSpendCapacityString = helper.prevDisplayText
                                bucketSheetVM.spendCapacity = helper.numberValue
                            })
                    }
                    
                    VStack(alignment: .trailing, spacing: 1.0){
                        Text("Rollover")
                            .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                            .foregroundColor(AppColor.normalMoreContrast)
                        Toggle("", isOn: $bucketSheetVM.rolloverEnabled)
                                .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.inputFieldSize))
                                .tint(AppColor.primary)
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
                let transactions = homeViewModel.transactionsInBucket(bucketSheetVM.bucketId())
                let count = transactions.count
                ForEach((0..<count).reversed() , id: \.self) { i in
                    let trans = transactions[i]
                    let displayName = transactionViewModel.transactionOwnerDisplayName(trans)
                    TransactionListElementView(transaction: trans, bucketName: trans.merchantName, ownerDisplayName: displayName)
                }
                .onDelete(perform:{ offsets in
                    homeViewModel.removeTransactionFromBudget(offsets, bucketSheetVM.bucketId())
                })
            }
            .listStyle(.plain)
        }
    }
}



