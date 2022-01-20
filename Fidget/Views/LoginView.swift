//
//  LoginView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI


struct LoginView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var username: String = ""
    @State private var password: String = ""
    
    
    let appFontMainRegular = AppFonts().mainFontBold
    var body: some View {
        
        VStack{
            Spacer()
            VStack(){
            
            Text("PIGG")
            //.font(.title)
                .tracking(-2.0)
                .font(Font.custom(appFontMainRegular,size: 50))
                .foregroundColor(ColorPallete().accentColor)
            
            TextField("Username", text: $username)
                .font(Font.custom(appFontMainRegular,size:15))
                .foregroundColor(ColorPallete().mediumFGColor)
                .accentColor(ColorPallete().accentColor)
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                
                .background(ColorPallete().mediumBGColor)
                .cornerRadius(30)
                .overlay(RoundedRectangle(cornerRadius: 30)
                            .stroke(ColorPallete().mediumFGColor)
                )
                .padding(EdgeInsets(top: 5, leading: 30, bottom: 0, trailing: 30))
            
            SecureField("Password", text: $password)
                .font(Font.custom(appFontMainRegular,size:15))
                .foregroundColor(ColorPallete().mediumFGColor)
                .accentColor(ColorPallete().accentColor)
                .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                
                .background(ColorPallete().mediumBGColor)
                .cornerRadius(30)
                .overlay(RoundedRectangle(cornerRadius: 30)
                            .stroke(ColorPallete().mediumFGColor)
                )
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 5, trailing: 30))
            }
            
            Spacer()
            VStack(){
                HStack(){
                    Text("Don't have an account?")
                        .foregroundColor(ColorPallete().lightBGColor)
                        .font(Font.custom(appFontMainRegular,size:15))
                    Button(action: {
                        //go to register view
                    }, label: {
                        Text("Register")
                            .foregroundColor(ColorPallete().lightFGColor)
                            .font(Font.custom(appFontMainRegular,size:15))
                    })
                }
                Button(action: {
                    appState.loggedIn = true
                }, label: {
                    ZStack(){
                        RoundedRectangle(cornerRadius: 25)
                            .foregroundColor(ColorPallete().lightFGColor)
                            .frame(width: 280, height: 40, alignment: .center)
                        Text("Sign In")
                        
                            .foregroundColor(ColorPallete().lightBGColor)
                            .font(Font.custom(appFontMainRegular,size:15))
                    }
                })
                
                    .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
                
            }
            Spacer()
                .frame(maxHeight: 30)
            
        }
        .background(ColorPallete().bgColor)
        
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

