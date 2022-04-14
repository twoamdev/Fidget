//
//  TransactionListElementView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/19/22.
//

import SwiftUI

struct TransactionListItem: View {
    @EnvironmentObject var transVM : TransactionViewModel
    var transaction : Transaction
    var bucketName : String
    var budgetDataUtils = BudgetDataUtils()
    
    var body: some View {
        VStack(){
            HStack(){
                Image(systemName: "bag.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(AppColor.normalMoreContrast)
                VStack(alignment: .leading){
                    Text(bucketName)
                        .font(Font.custom(AppFonts.mainFontMedium, size: 15))
                    let formattedDate : String = budgetDataUtils.formatDateAsSimpleTimeSinceNow(transaction.getDate())
                    Text(formattedDate)
                        .font(Font.custom(AppFonts.mainFontMedium, size: 15))
                        .foregroundColor(AppColor.normalMoreContrast)
                }
                .padding()
                Spacer()
                VStack(alignment: .trailing){
                    Text(String.localizedStringWithFormat("%@%.2f", "$", transaction.amount))
                        .font(Font.custom(AppFonts.mainFontMedium, size: 20))
                    
                    let displayName = transVM.transactionOwnerDisplayName(transaction)
                    Text(displayName)
                        .font(Font.custom(AppFonts.mainFontMedium, size: 15))
                        .foregroundColor(displayName == FirebaseUtils.noUserFound ? AppColor.normalMoreContrast : AppColor.primary)
                }
                .padding()
            }
        }
       
    }
    
}

