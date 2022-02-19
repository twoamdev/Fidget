//
//  BucketSheetView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/20/22.
//

import SwiftUI

struct BucketSheetView: View {
    @EnvironmentObject var homeViewModel : HomeViewModel
    var bucket: Bucket
    var bucketBalance : Double
    var body: some View {
        
        VStack(){
            progress
            transactionBody
        }
        
    }
    
    var progress : some View {
        VStack(){
            Text(bucket.name)
                .font(Font.custom(AppFonts().mainFontMedium, size: 30))
                .foregroundColor(ColorPallete().mediumBGColor)
                .tracking(-1.5)
            let moneyLeft = Int((bucket.capacity) - bucketBalance)
            let progressColor = bucketBalance >= bucket.capacity ? Color.red : ColorPallete().accentColor
            ZStack(){
                VStack(spacing: -10){
                    Text("$"+String(moneyLeft))
                        .font(Font.custom(AppFonts().mainFontMedium, size: 40))
                        .foregroundColor(ColorPallete().accentColor)
                        .tracking(-2)
                    if bucket.rolloverEnabled{
                    let rolloverSign = bucket.rolloverCapacity >= .zero ? "+" : "-"
                    let rolloverText = bucket.rolloverEnabled ? "\(rolloverSign) $\(Int(abs(bucket.rolloverCapacity))) " : ""
                    Text(rolloverText)
                        .font(Font.custom(AppFonts().mainFontRegular, size: 30))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
                        .background(rolloverSign == "+" ? .blue : .red)
                        .cornerRadius(30)
                        .padding(EdgeInsets(top: 0, leading: -3, bottom: 0, trailing: 0))
                    }
                    Text(" remains ")
                        .font(Font.custom(AppFonts().mainFontMedium, size: 25))
                        .foregroundColor(ColorPallete().accentColor)
                        .tracking(-2)
                    
                }
                let percentage = bucketBalance / (bucket.capacity + bucket.rolloverCapacity)
                CircularProgressView(percentage: percentage, bgcolor: progressColor, fillColor:ColorPallete().mediumBGColor, strokeWidth: 20.0)
                    .frame(width: 150.0, height: 150.0)
                    .padding(0)
            }
            let spent = bucketBalance
            Text("Spent $\(Int(spent))")
                .font(Font.custom(AppFonts().mainFontMedium, size: 30))
                .foregroundColor(ColorPallete().mediumBGColor)
                .tracking(-1.5)
            if bucket.rolloverEnabled{
                Text("ROLL OVER ENABLED")
            }
        }
    }
    
    var transactionBody : some View {
        VStack(){
            List{
                let transactions = homeViewModel.transactionsInBucket(bucket.id)
                let count = transactions.count
                ForEach((0..<count).reversed() , id: \.self) { i in
                    let trans = transactions[i]
                    TransactionDisplayView(transaction: trans)
                }
                .onDelete(perform:{ offsets in
                    homeViewModel.removeTransactionFromBudget(offsets, bucket.id)
                })
            }
            .listStyle(.plain)
        }
    }
}

struct TransactionDisplayView : View {
    var transaction : Transaction
    var body : some View{
        VStack(){
            HStack(){
                Image(systemName: "bag.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                VStack(alignment: .leading){
                    Text("Merchant: \(transaction.merchantName)")
                        .font(Font.custom(AppFonts().mainFontMedium, size: 15))
                    Text("DATE")
                    //Text("Date: \(transaction.getDate())")
                    //    .font(Font.custom(AppFonts().mainFontMedium, size: 15))
                }
                .padding()
                Spacer()
                VStack(alignment: .trailing){
                    Text(String.localizedStringWithFormat("%@%.2f", "$", transaction.amount))
                        .font(Font.custom(AppFonts().mainFontMedium, size: 20))
                }
                .padding()
            }
            
            
            
            /*
            Divider()
            Text("Notes: \(transaction.note)")
                .font(Font.custom(AppFonts().mainFontMedium, size: 15))
             */
        }
        .padding()
    }
}


struct BucketSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BucketSheetView(bucket: Bucket(name: "Bucket Name", capacity: 340, rollover: true), bucketBalance: 30)
    }
}

