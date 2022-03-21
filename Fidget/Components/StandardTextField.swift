//
//  StandardTextField.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/25/22.
//

import SwiftUI

struct StandardTextField: View {
    var locked : Bool
    var label : String
    @Binding var text : String
    @Binding var verified : Bool
    @Binding var loading : Bool
    @Binding var errorMessage : String
    @Binding var infoMessage : String
    @Binding var showPassword : Bool
    
    init( locked : Bool = false,
          label : String,
          text : Binding<String>,
          verifier : Binding<Bool> = .constant(false),
          loading : Binding<Bool> = .constant(false),
          errorMessage : Binding<String> = .constant(String()),
          infoMessage : Binding<String> = .constant(String()),
          showPassword : Binding<Bool> = .constant(false))
    {
        self.locked = locked
        self.label = label
        self._text = text
        self._verified = verifier
        self._loading = loading
        self._errorMessage = errorMessage
        self._infoMessage = infoMessage
        self._showPassword = showPassword
    }
    
    
    
    
    var body: some View {
       normal
    }
    
    var normal : some View {
        textField
    }
    
    var normalSecure : some View {
        secureField
    }
    
    var normalWithVerify : some View {
        VStack(){
            HStack{
                informationMessage
                Spacer()
                statusIndicator
            }
            textField
        }
    }
    var normalSecureWithVerify : some View {
        VStack(){
            HStack{
                informationMessage
                Spacer()
                statusIndicator
            }
            ZStack{
                if self.showPassword{
                    textField
                }
                else{
                    secureField
                }
                HStack{
                    Spacer()
                    VStack{
                        Button(action: {
                            self.showPassword.toggle()
                        },label: {
                            if self.showPassword{
                                Image(systemName: "eye.fill")
                                    .foregroundColor(AppColor.primary)
                            }
                            else{
                                Image(systemName: "eye.slash.fill")
                                    .foregroundColor(AppColor.primary)
                            }
                        })
                    }
                    .padding(.horizontal)
                }
            }
            
        }
    }
    
    
    
    private var secureField : some View {
        SecureField(label, text: self.$text)
            .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.inputFieldSize))
            .padding()
            .foregroundColor(AppColor.primary)
            .accentColor(AppColor.primary)
            .background(AppColor.normal)
            .cornerRadius(14)
            .overlay(RoundedRectangle(cornerRadius: AppStyle.cornerRadius)
                        .stroke(AppColor.normal)
            )
            .controlSize(.large)
    }
    
    private var textField : some View {
        VStack{
            let isLocked = self.locked
            let myFont = isLocked ? AppFonts.mainFontRegular : AppFonts.mainFontBold
        TextField(label, text: self.$text)
                .font(Font.custom(myFont, size: AppFonts.inputFieldSize))
            .padding()
            .foregroundColor(isLocked ? AppColor.primary : AppColor.primary)
            .accentColor(isLocked ? AppColor.normalLight : AppColor.primary)
            .background(isLocked ? AppColor.normalLight : AppColor.normal)
            .cornerRadius(AppStyle.cornerRadius)
            .overlay(RoundedRectangle(cornerRadius: AppStyle.cornerRadius)
                        .stroke(isLocked ? AppColor.normal : AppColor.normal)
            )
            .controlSize(.large)
            .disabled(isLocked)
        }
    }
    
    private var informationMessage : some View {
        VStack{
            let error = self.errorMessage
            if error.isEmpty {
                Text(self.infoMessage)
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(AppColor.normalMoreContrast)
            }
            else{
                Text(self.errorMessage)
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(AppColor.alert)
            }
        }
    }
    
    private var statusIndicator : some View {
        VStack{
            let error = self.errorMessage
            if !error.isEmpty {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(AppColor.alert)
            }
            else{
                if !self.text.isEmpty {
                    if self.loading{
                            ProgressView()
                                .scaleEffect(0.75)
                                .mask(
                                    Image(systemName: "circle.fill")
                                        .foregroundColor(AppColor.normal)
                                )
                    }
                    else{
                        if self.verified{
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppColor.green)
                        }
                        else{
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(AppColor.alert)
                        }
                    }
                }
                else{
                    Image(systemName: "circle.fill")
                        .foregroundColor(AppColor.normal)
                }
            }
        }
    }
}

/*
struct StandardTextField_Previews: PreviewProvider {
    static var previews: some View {
        StandardTextField("username", .constant(""))
    }
}
*/
