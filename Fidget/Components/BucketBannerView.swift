//
//  BucketBannerView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/21/22.
//

import SwiftUI

struct BucketBannerView: View {
    
    var body: some View {
        HStack(){
            VStack(alignment: .leading, spacing:0){
                Text("Feb")
                    .font(Font.custom(AppFonts().mainFontRegular, size: 40))
                    .foregroundColor(ColorPallete().mediumBGColor)
                
                
                let lineWidth = 3.0
                Path() { path in
                    path.move(to: CGPoint(x: 2, y: 0))
                    path.addLine(to: CGPoint(x: 50, y: 0))
                    //path.addLine(to: CGPoint(x: geo.size.width, y: lineWidth))
                    //path.addLine(to: CGPoint(x: 0, y: lineWidth))
                }
                .stroke(lineWidth: lineWidth)
                .frame(height: 1.0)
                Text("2022")
                    .font(Font.custom(AppFonts().mainFontRegular, size: 40))
                    .foregroundColor(ColorPallete().mediumBGColor)
                
            }
            
           
        }
    }
}

struct BucketBannerView_Previews: PreviewProvider {
    static var previews: some View {
        BucketBannerView()
    }
}
