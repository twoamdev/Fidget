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
    var pressLoading : Bool
    
    
    init(label : String, function : @escaping () -> Void = {}, pressLoading : Bool = false)
    {
        self.label = label
        self.function = function
        self.pressLoading = pressLoading
    }
    
    
    var body: some View {
        primaryButtonLarge
    }
    
    var primaryButtonLarge : some View {
        Button( action : {
            self.function()
        }){
            labelSectionNormal
                .frame(maxWidth: .infinity)
        }
        .tint(AppColor.primary)
        .buttonStyle(.borderedProminent)
        .cornerRadius(AppStyle.cornerRadius)
        .controlSize(.large)
    }
    
    var primaryButtonLabelLarge : some View {
        VStack{
            labelSectionNormal
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
            labelSection
                .frame(maxWidth: .infinity)
        }
        .tint(AppColor.normal)
        .buttonStyle(.borderedProminent)
        .cornerRadius(AppStyle.cornerRadius)
        .controlSize(.large)
    }
    
    var normalButtonLabelLarge : some View {
        VStack{
            labelSection
                .frame(maxWidth: .infinity)
                .padding()
            
        }
        .background(AppColor.normal)
        .cornerRadius(AppStyle.cornerRadius)
    }
    
    private var labelSection : some View {
        HStack{
            if pressLoading{
                ProgressView()
                    .foregroundColor(AppColor.normal)
            }
            else{
                Text(label)
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.buttonLabelSize))
                    .foregroundColor(AppColor.primary)
            }
        }
    }
    
    private var labelSectionNormal : some View {
        HStack{
            if pressLoading{
                ProgressView()
                    .foregroundColor(AppColor.primary)
            }
            else{
                Text(label)
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.buttonLabelSize))
                    .foregroundColor(AppColor.normal)
            }
        }
    }
    
}

/*
struct StandardButton_Previews: PreviewProvider {
    static var previews: some View {
        StandardButton(label: "SIGN IN", function: {print("eh")}).normalButtonLarge
    }
}
*/
