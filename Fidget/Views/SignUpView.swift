//
//  SignUpView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/22/22.
//

import SwiftUI

struct SignUpView: View {
    @Binding var showRegister : Bool
    @State private var emailSignUp: String = ""
    @State private var passwordSignUp: String = ""
    @State private var confirmPasswordSignUp: String = ""
    var body: some View {
        VStack(){
            Spacer()
            
            TextFieldView(label: "Email", userInput: emailSignUp).standardTextField
            TextFieldView(label: "Password", userInput: passwordSignUp).standardTextField
            TextFieldView(label: "Confirm Password", userInput: confirmPasswordSignUp).standardTextField
            Spacer()
            Button(action: {
                showRegister.toggle()
            }, label: {
               
                    ZStack(){
                        
                        RoundedRectangle(cornerRadius: 4.0)
                            .foregroundColor(ColorPallete().mediumFGColor)
                            .frame(width: 140, height: 40, alignment: .center)
                        Text("Sign Up")
                        
                            .foregroundColor(ColorPallete().mediumBGColor)
                            .font(Font.custom(AppFonts().mainFontRegular,size:15))
                    }
                
            })
            Spacer()
            
        }
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(showRegister: .constant(true))
    }
}

