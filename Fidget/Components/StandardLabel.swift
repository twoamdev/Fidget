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
    var body: some View {
        HStack{
            let labelIconPresent = labelIconName?.isEmpty ?? "".isEmpty ? false : true
            if labelIconPresent {
                Image(systemName: labelIconName ?? "")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: AppFonts.inputFieldSize)
                    .foregroundColor(AppColor.primary)
            }
            Text(labelText ?? "Empty Field")
                .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.inputFieldSize))
                .foregroundColor(AppColor.primary)
            Spacer()
        }
    }
}

struct StandardLabel_Previews: PreviewProvider {
    static var previews: some View {
        StandardLabel()
    }
}
