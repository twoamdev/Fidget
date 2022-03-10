//
//  StandardTextField.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/25/22.
//

import SwiftUI

struct StandardTextField: View {
    var label : String
    @Binding var text : String
    @Binding var verified : Bool
    @Binding var loading : Bool
    @Binding var errorMessage : String
    @Binding var showPassword : Bool
    
    init(_ label : String, _ text : Binding<String>){
        self.label = label
        self._text = text
        self._verified = Binding<Bool>.constant(false)
        self._loading = Binding<Bool>.constant(false)
        self._errorMessage = Binding<String>.constant("")
        self._showPassword = Binding<Bool>.constant(false)
    }
    
    init(_ label : String, _ text : Binding<String>, verifier : Binding<Bool>){
        self.label = label
        self._text = text
        self._verified = verifier
        self._loading = Binding<Bool>.constant(false)
        self._errorMessage = Binding<String>.constant("")
        self._showPassword = Binding<Bool>.constant(false)
    }
    
    init(_ label : String, _ text : Binding<String>, verifier : Binding<Bool>, errorMessage : Binding<String>){
        self.label = label
        self._text = text
        self._verified = verifier
        self._loading = Binding<Bool>.constant(false)
        self._errorMessage = errorMessage
        self._showPassword = Binding<Bool>.constant(false)
    }
    
    init(_ label : String, _ text : Binding<String>, verifier : Binding<Bool>, errorMessage : Binding<String>, showPassword : Binding<Bool>){
        self.label = label
        self._text = text
        self._verified = verifier
        self._loading = Binding<Bool>.constant(false)
        self._errorMessage = errorMessage
        self._showPassword = showPassword
    }
    
    init(_ label : String, _ text : Binding<String>, verifier : Binding<Bool>, loading : Binding<Bool>){
        self.label = label
        self._text = text
        self._verified = verifier
        self._loading = loading
        self._errorMessage = Binding<String>.constant("")
        self._showPassword = Binding<Bool>.constant(false)
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
                errorInfo
                Spacer()
                statusIndicator
            }
            textField
        }
    }
    var normalSecureWithVerify : some View {
        VStack(){
            HStack{
                errorInfo
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
        TextField(label, text: self.$text)
            .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.inputFieldSize))
            .padding()
            .foregroundColor(AppColor.primary)
            .accentColor(AppColor.primary)
            .background(AppColor.normal)
            .cornerRadius(AppStyle.cornerRadius)
            .overlay(RoundedRectangle(cornerRadius: AppStyle.cornerRadius)
                        .stroke(AppColor.normal)
            )
            .controlSize(.large)
    }
    
    private var errorInfo : some View {
        Text(self.errorMessage)
            .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
            .foregroundColor(AppColor.alert)
    }
    
    private var statusIndicator : some View {
        VStack{
            if !self.errorMessage.isEmpty {
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
                        if self.verified {
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

struct StandardTextField_Previews: PreviewProvider {
    static var previews: some View {
        StandardTextField("Username",.constant("mrbennelson"), verifier: .constant(true), loading: .constant(false)).normalWithVerify
    }
}
