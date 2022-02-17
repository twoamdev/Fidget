//
//  BucketSheetView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/20/22.
//

import SwiftUI

struct BucketSheetView: View {
    var bucket: Bucket
    var bucketBalance : Double
    var body: some View {
        ZStack(){
            ColorPallete().mediumFGColor
                VStack(){
                    Text(bucket.name)
                        .font(Font.custom(AppFonts().mainFontMedium, size: 30))
                        .foregroundColor(ColorPallete().mediumBGColor)
                        .tracking(-1.5)
                    let displayValue = bucketBalance
                    let moneyLeft = Int(bucket.capacity - displayValue)
                    let progressColor = bucketBalance >= bucket.capacity ? Color.red : ColorPallete().accentColor
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
                        CircularProgressView(percentage: bucketBalance / bucket.capacity, bgcolor: progressColor, fillColor:ColorPallete().mediumBGColor, strokeWidth: 20.0)
                            .frame(width: 150.0, height: 150.0)
                            .padding(0)
                    }
                    let spent = bucketBalance
                    Text("Spent $\(Int(spent))")
                        .font(Font.custom(AppFonts().mainFontMedium, size: 30))
                        .foregroundColor(ColorPallete().mediumBGColor)
                        .tracking(-1.5)
                }
        }
        
    }
    
    
}

/*
struct BucketSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BucketSheetView(bucket: Bucket(name: "Bucket Name", value: 200, capacity: 340, rollover: true))
    }
}
 */
