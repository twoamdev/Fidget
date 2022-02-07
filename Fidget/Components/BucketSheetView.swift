//
//  BucketSheetView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/20/22.
//

import SwiftUI

struct BucketSheetView: View {
    var bucket: Bucket
    var body: some View {
        ZStack(){
            ColorPallete().mediumFGColor
            VStack(){
                
                VStack(){
                    Text(bucket.name)
                        .font(Font.custom(AppFonts().mainFontMedium, size: 30))
                        .foregroundColor(ColorPallete().mediumBGColor)
                        .tracking(-1.5)
                    let displayValue = 0.0
                    let moneyLeft = Int(bucket.capacity - displayValue)
                    let progressColor = bucket.value >= 1.0 ? Color.red : ColorPallete().accentColor
                    ZStack(){
                        VStack(spacing: -10){
                            Text("$"+String(moneyLeft))
                                .font(Font.custom(AppFonts().mainFontMedium, size: 40))
                                .foregroundColor(ColorPallete().accentColor)
                                .tracking(-2)
                            Text(" remains ")
                                .font(Font.custom(AppFonts().mainFontMedium, size: 25))
                                .foregroundColor(ColorPallete().accentColor)
                                .tracking(-2)
                            
                        }
                        CircularProgressView(percentage: bucket.value, bgcolor: progressColor, fillColor:ColorPallete().mediumBGColor, strokeWidth: 20.0)
                            .frame(width: 150.0, height: 150.0)
                            .padding(0)
                    }
                    let spent = bucket.capacity * bucket.value
                    Text("Spent $\(Int(spent))")
                        .font(Font.custom(AppFonts().mainFontMedium, size: 30))
                        .foregroundColor(ColorPallete().mediumBGColor)
                        .tracking(-1.5)
                }
                .padding(30.0)
                Spacer()
                
                let transactions = ["Spent $30", "Spent $54.39 -- at Trader Joe's", "Spent 23.40 -- at Target"]
                ScrollView {
                    VStack(spacing:0){
                        ForEach(transactions, id: \.self) { transaction in
                            Divider()
                            TransactionCardView(transaction: transaction)
                            
                        }
                    }
                    
                    
                }
                
                
                
                
            }
            
            
        }
        
    }
    
    
}

struct BucketSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BucketSheetView(bucket: Bucket(name: "Bucket Name", value: 0.35, capacity: 340, rollover: true))
    }
}
