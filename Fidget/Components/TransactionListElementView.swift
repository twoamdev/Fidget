//
//  TransactionListElementView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/19/22.
//

import SwiftUI

struct TransactionListElementView: View {
    var transaction : Transaction
    var bucketName : String
    var ownerDisplayName : String
    var budgetDataUtils = BudgetDataUtils()
    var body: some View {
        VStack(){
            HStack(){
                Image(systemName: "bag.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading){
                    Text(bucketName)
                        .font(Font.custom(AppFonts.mainFontMedium, size: 15))
                    let formattedDate : String = budgetDataUtils.formatDateAsSimpleTimeSinceNow(transaction.getDate())
                    Text(formattedDate)
                        .font(Font.custom(AppFonts.mainFontMedium, size: 15))
                }
                .padding()
                Spacer()
                VStack(alignment: .trailing){
                    Text(String.localizedStringWithFormat("%@%.2f", "$", transaction.amount))
                        .font(Font.custom(AppFonts.mainFontMedium, size: 20))
                    
                    Text(ownerDisplayName)
                        .font(Font.custom(AppFonts.mainFontMedium, size: 15))
                        .foregroundColor(.blue)
                }
                .padding()
            }
            
            
            
            /*
             Divider()
             Text("Notes: \(transaction.note)")
             .font(Font.custom(AppFonts().mainFontMedium, size: 15))
             */
        }
        //.padding()
    }
    
}

struct TransactionListElementView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListElementView(transaction: Transaction("oijwerij", "Groceries", "Harris Teeter", 90.0, "bought this week's groceries"), bucketName: "Bucket Name", ownerDisplayName: "Garet Nelson")
    }
}
