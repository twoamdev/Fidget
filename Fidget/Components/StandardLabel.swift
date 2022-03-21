//
//  StandardLabel.swift
//  Fidget
//
//  Created by Ben Nelson on 3/12/22.
//

import SwiftUI

struct StandardLabel: View {
    var labelText : String?
    var labelIconName : String?
    var showNavArrow : Bool?
    var customColor : Color?

    
    var body: some View {
        VStack{
            HStack{
                let labelIconPresent = labelIconName?.isEmpty ?? "".isEmpty ? false : true
                if labelIconPresent {
                    Image(systemName: labelIconName ?? "")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: AppFonts.inputFieldSize)
                        .foregroundColor(customColor ?? AppColor.primary)
                }
                Text(labelText ?? "Empty Field")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.inputFieldSize))
                    .foregroundColor(customColor ?? AppColor.primary)
                Spacer()
                if showNavArrow ?? false{
                    Image(systemName: "chevron.right")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: (AppFonts.inputFieldSize / 2.0))
                        .foregroundColor(AppColor.normalMoreContrast)
                }
            }
        }.contentShape(Rectangle())
        
    }
}

struct StandardLabel_Previews: PreviewProvider {
    static var previews: some View {
        StandardLabel()
    }
}
