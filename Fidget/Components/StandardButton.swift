//
//  StandardButton.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/24/22.
//

import SwiftUI


struct StandardButton: View {
    var lockedLookStyle : Bool
    var label : String
    var function : () -> Void
    var pressLoading : Bool
    
    
    init(lockedStyle : Bool = false, label : String, function : @escaping () -> Void = {}, pressLoading : Bool = false)
    {
        self.lockedLookStyle = lockedStyle
        self.label = label
        self.function = function
        self.pressLoading = pressLoading
    }
    
    
    var body: some View {
        primaryButtonLarge
    }
    
    var primaryButtonShrinkWrap : some View {
        Button( action : {
            self.function()
        }){
            labelSectionNormal
        }
        .tint(lockedLookStyle ? AppColor.normalLight : AppColor.primary)
        .buttonStyle(.borderedProminent)
        .cornerRadius(AppStyle.cornerRadius * 0.7)
        .controlSize(.regular)
    }
    
    var primaryLabelShrinkWrap : some View {
        ZStack{
            primaryButtonShrinkWrap
                .opacity(0)
            labelSectionNormal
        }
        .background(lockedLookStyle ? AppColor.normalLight : AppColor.primary)
        .cornerRadius(AppStyle.cornerRadius * 0.7)
    }
    
    var normalButtonShrinkWrap : some View {
        Button( action : {
            self.function()
        }){
            labelSection
        }
        .tint(AppColor.normal)
        .buttonStyle(.borderedProminent)
        .cornerRadius(AppStyle.cornerRadius * 0.7)
        .controlSize(.regular)
    }
    
    var primaryButtonLarge : some View {
        Button( action : {
            self.function()
        }){
            labelSectionNormal
                .frame(maxWidth: .infinity)
        }
        .tint(lockedLookStyle ? AppColor.normalLight : AppColor.primary)
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
        .background(lockedLookStyle ? AppColor.normalLight : AppColor.primary)
        .cornerRadius(AppStyle.cornerRadius)
    }
    
    var normalButtonLarge : some View {
        Button( action : {
            self.function()
        }){
            labelSection
                .frame(maxWidth: .infinity)
        }
        .tint(lockedLookStyle ? AppColor.normalLight : AppColor.normal)
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
        .background(lockedLookStyle ? AppColor.normalLight : AppColor.normal)
        .cornerRadius(AppStyle.cornerRadius)
    }
    
    private var labelSection : some View {
        HStack{
            if pressLoading{
                ProgressView()
                    .foregroundColor(lockedLookStyle ? AppColor.normalLight : AppColor.normal)
            }
            else{
                Text(label)
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.buttonLabelSize))
                    .foregroundColor(lockedLookStyle ? AppColor.normalMoreContrast : AppColor.primary)
            }
        }
    }
    
    private var labelSectionNormal : some View {
        HStack{
            if pressLoading{
                ProgressView()
                    .foregroundColor(lockedLookStyle ? AppColor.normalMoreContrast : AppColor.primary)
            }
            else{
                Text(label)
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.buttonLabelSize))
                    .foregroundColor(lockedLookStyle ? AppColor.normalMoreContrast : AppColor.normal)
            }
        }
    }
    
}


struct StandardButton_Previews: PreviewProvider {
    static var previews: some View {
        StandardButton(label: "SIGN IN", function: {print("eh")}).primaryLabelShrinkWrap
            
    }
}

