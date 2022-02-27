//
//  StandardButton.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/24/22.
//

import SwiftUI


struct StandardButton: View {
    var label : String
    var function : () -> Void
    
    var body: some View {
        primaryButtonLarge
    }
    
    var primaryButtonLarge : some View {
        Button( action : {
            self.function()
        }){
            HStack{
                Text(label)
                .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.buttonLabelSize))
                .foregroundColor(AppColor.normal)
            }
            .frame(maxWidth: .infinity)
        }
        .tint(AppColor.primary)
        .buttonStyle(.borderedProminent)
        .cornerRadius(AppStyle.cornerRadius)
        .controlSize(.large)
    }
    
    var primaryButtonLabelLarge : some View {
        VStack{
            HStack{
                Text(label)
                .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.buttonLabelSize))
                .foregroundColor(AppColor.normal)
            }
            .frame(maxWidth: .infinity)
            .padding()
            
        }
        .background(AppColor.primary)
        .cornerRadius(AppStyle.cornerRadius)
    }
    
    var normalButtonLarge : some View {
        Button( action : {
            self.function()
        }){
            HStack{
                Text(label)
                .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.buttonLabelSize))
                .foregroundColor(.pink)
            }
            .frame(maxWidth: .infinity)
        }
        .tint(AppColor.normal)
        .buttonStyle(.borderedProminent)
        .cornerRadius(AppStyle.cornerRadius)
        .controlSize(.large)
    }
    
    var normalButtonLabelLarge : some View {
        VStack{
            HStack{
                Text(label)
                .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.buttonLabelSize))
                .foregroundColor(AppColor.primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            
        }
        .background(AppColor.normal)
        .cornerRadius(AppStyle.cornerRadius)
    }

}

struct StandardButton_Previews: PreviewProvider {
    static var previews: some View {
        StandardButton(label: "SIGN IN", function: {print("eh")}).normalButtonLarge
    }
}
