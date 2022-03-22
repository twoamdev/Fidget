//
//  BucketCardView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/20/22.
//

import SwiftUI

struct BucketCardView: View {
    @State private var showBucketDetails = false
    var bucket: Bucket
    var bucketBalance : Double
    var body: some View {
        
        
        VStack(){
            HStack(){
                let displayValue = bucketBalance
                let moneyLeft = Int((bucket.capacity + bucket.rolloverCapacity) - displayValue)
                let displayColor = moneyLeft >= 0 ? AppColor.fg : AppColor.alert
                let textDisplayColor = moneyLeft >= 0 ? AppColor.fg : AppColor.alert
                VStack(alignment: .leading, spacing: 0){
                    Text(bucket.name)
                        .font(Font.custom(AppFonts.mainFontBold, size: 20))
                        .foregroundColor(textDisplayColor)
                    HStack(){
                        let rolloverSign = bucket.rolloverCapacity >= .zero ? "+" : "-"
                        let rolloverText = bucket.rolloverEnabled ? "\(rolloverSign) $\(Int(abs(bucket.rolloverCapacity))) " : ""
                        Text("$\(Int(displayValue)) / $\(Int(bucket.capacity))")
                            .font(Font.custom(AppFonts.mainFontRegular, size: 15))
                            .foregroundColor(textDisplayColor)
                        if bucket.rolloverEnabled {
                            Text(rolloverText)
                                .font(Font.custom(AppFonts.mainFontRegular, size: 15))
                                .foregroundColor(.white)
                                .padding(EdgeInsets(top: 2, leading: 5, bottom: 2, trailing: 5))
                                .background(rolloverSign == "+" ? .blue : .red)
                                .cornerRadius(30)
                                .padding(EdgeInsets(top: 0, leading: -3, bottom: 0, trailing: 0))
                        }
                    }
                }
                
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                Spacer()
                
                Text(String(moneyLeft)+" ")
                    .font(Font.custom(AppFonts.mainFontMedium, size: 40))
                    .tracking(-1)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                    .foregroundColor(displayColor)
                
            }
        }
        .contentShape(Rectangle())
    }
}

/*
 struct BucketCardView_Previews: PreviewProvider {
 static var previews: some View {
 BucketCardView(bucket: Bucket(name: "Bucket Name", value: 200, capacity: 340, rollover: true))
 }
 }
 */
