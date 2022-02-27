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
    
    init(_ label : String, _ text : Binding<String>){
        self.label = label
        self._text = text
        self._verified = Binding<Bool>.constant(false)
        self._loading = Binding<Bool>.constant(false)
    }
    
    init(_ label : String, _ text : Binding<String>, verifier : Binding<Bool>){
        self.label = label
        self._text = text
        self._verified = verifier
        self._loading = Binding<Bool>.constant(false)
    }
    
    init(_ label : String, _ text : Binding<String>, verifier : Binding<Bool>, loading : Binding<Bool>){
        self.label = label
        self._text = text
        self._verified = verifier
        self._loading = loading
    }
    
    var body: some View {
       normal
    }
    
    var normal : some View {
        TextField(label, text: self.$text)
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
    
    var normalWithVerify : some View {
        VStack(){
            HStack{
                Spacer()
                if !self.text.isEmpty {
                    if self.loading{
                        ZStack{
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(AppColor.green)
                                .opacity(0.0)
                            ProgressView()
                                .scaleEffect(0.75)
                            }
                            
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
            }
            
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
    }
}

struct StandardTextField_Previews: PreviewProvider {
    static var previews: some View {
        StandardTextField("Username",.constant("g"), verifier: .constant(true), loading: .constant(true)).normalWithVerify
    }
}
