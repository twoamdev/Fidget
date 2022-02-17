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
        HStack(){
                HStack(){
                    
                    VStack(){
                        HStack(){
                            let displayValue = bucketBalance
                            let moneyLeft = Int(bucket.capacity - displayValue)
                            let displayColor = moneyLeft >= 0 ? ColorPallete().mediumBGColor : Color.red
                            let textDisplayColor = moneyLeft >= 0 ? ColorPallete().mediumBGColor : Color.red
                            VStack(alignment: .leading, spacing: 0){
                                Text(bucket.name)
                                    .font(Font.custom(AppFonts().mainFontBold, size: 20))
                                    .foregroundColor(textDisplayColor)
                                HStack(){
                                    Text("$\(Int(displayValue)) / $\(Int(bucket.capacity))")
                                        .font(Font.custom(AppFonts().mainFontRegular, size: 15))
                                        .foregroundColor(textDisplayColor)
                                }
                            }
                            
                            .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                            Spacer()
                            
                            Text(String(moneyLeft)+" ")
                                .font(Font.custom(AppFonts().mainFontMedium, size: 40))
                                .tracking(-2)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                                .foregroundColor(displayColor)
                            
                        }
                    }
                }
                .animation(.easeInOut)
        }
        .sheet(isPresented: $showBucketDetails) {
            BucketSheetView(bucket: bucket, bucketBalance: bucketBalance)
            
        }
        
        .onTapGesture{
            showBucketDetails.toggle()
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: -7.5, trailing: 0))
        
    }
}

/*
struct BucketCardView_Previews: PreviewProvider {
    static var previews: some View {
        BucketCardView(bucket: Bucket(name: "Bucket Name", value: 200, capacity: 340, rollover: true))
    }
}
*/
