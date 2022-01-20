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
                Text(bucket.name)
                    .font(Font.custom(AppFonts().mainFontMedium, size: 30))
                    .foregroundColor(ColorPallete().mediumBGColor)
                CircularProgressView(percentage: bucket.value, bgcolor: ColorPallete().mediumBGColor)
                    .frame(width: 150.0, height: 150.0)
                                        .padding(40.0)
            }
            
        }
        
    }
    
    
}

struct BucketSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BucketSheetView(bucket: Bucket(name: "Bucket Name", value: 0.35, capacity: 340))
    }
}
