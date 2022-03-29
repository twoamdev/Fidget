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
    var colorPrimary : Color
    var colorNormal : Color
    
    
    init(lockedStyle : Bool = false, label : String, function : @escaping () -> Void = {}, pressLoading : Bool = false, colorPrimary : Color = AppColor.primary, colorNormal : Color = AppColor.normal)
    {
        self.lockedLookStyle = lockedStyle
        self.label = label
        self.function = function
        self.pressLoading = pressLoading
        self.colorPrimary = colorPrimary
        self.colorNormal = colorNormal
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
        .tint(lockedLookStyle ? AppColor.normalLight : self.colorPrimary)
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
        .background(lockedLookStyle ? AppColor.normalLight : self.colorPrimary)
        .cornerRadius(AppStyle.cornerRadius * 0.7)
    }
    
    var normalButtonShrinkWrap : some View {
        Button( action : {
            self.function()
        }){
            labelSection
        }
        .tint(self.colorNormal)
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
        .tint(lockedLookStyle ? AppColor.normalLight : self.colorPrimary)
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
        .background(lockedLookStyle ? AppColor.normalLight : self.colorPrimary)
        .cornerRadius(AppStyle.cornerRadius)
    }
    
    var normalButtonLarge : some View {
        Button( action : {
            self.function()
        }){
            labelSection
                .frame(maxWidth: .infinity)
        }
        .tint(lockedLookStyle ? AppColor.normalLight : self.colorNormal)
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
        .background(lockedLookStyle ? AppColor.normalLight : self.colorNormal)
        .cornerRadius(AppStyle.cornerRadius)
    }
    
    private var labelSection : some View {
        HStack{
            if pressLoading{
                ProgressView()
                    .foregroundColor(lockedLookStyle ? AppColor.normalLight : self.colorNormal)
            }
            else{
                Text(label)
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.buttonLabelSize))
                    .foregroundColor(lockedLookStyle ? AppColor.normalMoreContrast : self.colorPrimary)
            }
        }
    }
    
    private var labelSectionNormal : some View {
        HStack{
            if pressLoading{
                ProgressView()
                    .foregroundColor(lockedLookStyle ? AppColor.normalMoreContrast : self.colorPrimary)
            }
            else{
                Text(label)
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.buttonLabelSize))
                    .foregroundColor(lockedLookStyle ? AppColor.normalMoreContrast : self.colorNormal)
            }
        }
    }
    
}


struct StandardButton_Previews: PreviewProvider {
    static var previews: some View {
        StandardButton(label: "SIGN IN", function: {print("eh")}).primaryLabelShrinkWrap
            
    }
}

