//
//  LoginView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI


struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var signUpViewModel : SignUpViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showRegister = false
    
    
    let appFontMainRegular = AppFonts().mainFontBold
    var body: some View {
        
        VStack{
            Spacer()
            VStack(){
                
                
                Text("PIGG")
                    .tracking(-2.0)
                    .font(Font.custom(appFontMainRegular,size: 50))
                    .foregroundColor(ColorPallete().mediumBGColor)
                
                TextFieldView(label: "Username",userInput: $username).standardTextField
                
                TextFieldView(label: "Password", userInput: $password).secureTextField
            }
            
            Spacer()
            
                HStack(){
                    ZStack(){
                        
                        RoundedRectangle(cornerRadius: 4.0)
                            .foregroundColor(ColorPallete().lightFGColor)
                            .frame(width: 140, height: 80, alignment: .center)
                        Text("Sign Up")
                        
                            .foregroundColor(ColorPallete().lightBGColor)
                            .font(Font.custom(appFontMainRegular,size:15))
                    }
                    .sheet(isPresented: $showRegister) {
                        SignUpView(showRegister: $showRegister)
                        
                    }
                    .onTapGesture{
                        showRegister.toggle()
                    }
                    
                    
                    
                    Button(action: {
                        appState.loggedIn = true
                    }, label: {
                        
                        ZStack(){
                            
                            RoundedRectangle(cornerRadius: 4.0)
                                .foregroundColor(ColorPallete().lightFGColor)
                                .frame(width: 140, height: 80, alignment: .center)
                            Text("Sign In")
                            
                                .foregroundColor(ColorPallete().lightBGColor)
                                .font(Font.custom(appFontMainRegular,size:15))
                        }
                        
                    })
                }
            
            Spacer()
                .frame(maxHeight: 30)
            
        }
        .background(ColorPallete().mediumFGColor)
        
    }
    
}

/*
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

*/
