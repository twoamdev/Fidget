//
//  BudgetInviteCardView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/28/22.
//

import SwiftUI

struct BudgetInviteCardView: View {
    @State var budgetName : String
    @State var requestUsername : String
    @Binding var selected : Bool
    @State var onAccept : () -> Void
    @State var onDecline : () -> Void
    
    
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text(budgetName)
                        .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.inputFieldSize * 1.23))
                        .foregroundColor(selected ? AppColor.bg : AppColor.fg)
                    
                    HStack(spacing: 3){
                        Image(systemName: "person.crop.circle.fill")
                            .font(Font.custom(AppFonts.mainFontMedium, size: AppFonts.inputFieldSize))
                            .foregroundColor(selected ? AppColor.bg : AppColor.primary)
                        
                
                            Text(requestUsername)
                                .font(Font.custom(AppFonts.mainFontMedium, size: AppFonts.inputFieldSize))
                                .foregroundColor(selected ? AppColor.bg : AppColor.primary)
                        
                    }
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 8){
                    StandardButton(label: "ACCEPT", function:
                                    self.onAccept , colorPrimary: AppColor.primary, colorNormal: AppColor.bg
                    ).normalButtonShrinkWrap
                    StandardButton(label: "DECLINE", function:
                                    self.onDecline , colorPrimary: selected ? AppColor.normalMoreContrast : AppColor.fg, colorNormal: AppColor.bg
                    ).normalButtonShrinkWrap
                }
            }
            .padding()
            .background(selected ? AppColor.primary :AppColor.normal)
            .cornerRadius(AppStyle.cornerRadius)
            
        }
    }
}


struct BudgetInviteCardView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetInviteCardView(budgetName: "Nelson Family Budget", requestUsername: "garetnelson", selected: .constant(true), onAccept: {}, onDecline: {})
    }
}
 
