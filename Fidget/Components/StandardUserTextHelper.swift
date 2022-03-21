//
//  StandardUserTextHelper.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/26/22.
//

import SwiftUI

struct StandardUserTextHelper: View {
    var message : String
    @Binding var indicator : Bool
    
    var body: some View {
        HStack(spacing: 0){
            if indicator {
                Image(systemName: "checkmark.circle.fill")
                    .scaleEffect(0.7)
                    .foregroundColor(AppColor.green)
            }
            else{
                Image(systemName: "xmark.circle.fill")
                    .scaleEffect(0.7)
                    .foregroundColor(AppColor.normal)
            }
            
            let textColor = indicator ? AppColor.fg : AppColor.normalMoreContrast
            Text(message)
                .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                .foregroundColor(textColor)
        }
    }
}

struct StandardUserTextHelper_Previews: PreviewProvider {
    static var previews: some View {
        StandardUserTextHelper(message: "Only fix it okay", indicator: .constant(false))
    }
}
