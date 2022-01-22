//
//  SignUpView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/22/22.
//

import SwiftUI

struct SignUpView: View {
   
    @State private var emailSignUp: String = ""
    @State private var passwordSignUp: String = ""
    @State private var confirmPasswordSignUp: String = ""
    var body: some View {
        VStack(){
            Spacer()
            
            TextField("Email", text: $emailSignUp)
                .font(Font.custom(AppFonts().mainFontRegular,size:15))
                .foregroundColor(ColorPallete().mediumBGColor)
                .accentColor(ColorPallete().accentColor)
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
            
                .background(ColorPallete().lightFGColor)
                .cornerRadius(4.0)
                .overlay(RoundedRectangle(cornerRadius: 4.0)
                            .stroke(ColorPallete().mediumFGColor)
                )
                .padding(EdgeInsets(top: 5, leading: 30, bottom: 0, trailing: 30))
            
            TextField("Password", text: $passwordSignUp)
                .font(Font.custom(AppFonts().mainFontRegular,size:15))
                .foregroundColor(ColorPallete().mediumBGColor)
                .accentColor(ColorPallete().accentColor)
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
            
                .background(ColorPallete().lightFGColor)
                .cornerRadius(4.0)
                .overlay(RoundedRectangle(cornerRadius: 4.0)
                            .stroke(ColorPallete().mediumFGColor)
                )
                .padding(EdgeInsets(top: 5, leading: 30, bottom: 0, trailing: 30))
            TextField("Confirm Password", text: $confirmPasswordSignUp)
                .font(Font.custom(AppFonts().mainFontRegular,size:15))
                .foregroundColor(ColorPallete().mediumBGColor)
                .accentColor(ColorPallete().accentColor)
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
            
                .background(ColorPallete().lightFGColor)
                .cornerRadius(4.0)
                .overlay(RoundedRectangle(cornerRadius: 4.0)
                            .stroke(ColorPallete().mediumFGColor)
                )
                .padding(EdgeInsets(top: 5, leading: 30, bottom: 0, trailing: 30))
            Spacer()
            Button(action: {
                
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

/*
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(show: true)
    }
}
*/
