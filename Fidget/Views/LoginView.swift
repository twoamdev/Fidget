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
    @State private var showRegister = false
    
    
    let appFontMainRegular = AppFonts().mainFontBold
    var body: some View {
        
        VStack{
            Spacer()
            VStack(){
                
                let myRadius = 4.0
                Text("PIGG")
                //.font(.title)
                    .tracking(-2.0)
                    .font(Font.custom(appFontMainRegular,size: 50))
                    .foregroundColor(ColorPallete().mediumBGColor)
                
                TextField("Username", text: $username)
                    .font(Font.custom(appFontMainRegular,size:15))
                    .foregroundColor(ColorPallete().mediumBGColor)
                    .accentColor(ColorPallete().accentColor)
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                
                    .background(ColorPallete().lightFGColor)
                    .cornerRadius(myRadius)
                    .overlay(RoundedRectangle(cornerRadius: myRadius)
                                .stroke(ColorPallete().mediumFGColor)
                    )
                    .padding(EdgeInsets(top: 5, leading: 30, bottom: 0, trailing: 30))
                
                SecureField("Password", text: $password)
                    .font(Font.custom(appFontMainRegular,size:15))
                    .foregroundColor(ColorPallete().mediumBGColor)
                    .accentColor(ColorPallete().accentColor)
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                
                    .background(ColorPallete().lightFGColor)
                    .cornerRadius(myRadius)
                    .overlay(RoundedRectangle(cornerRadius: myRadius)
                                .stroke(ColorPallete().mediumFGColor)
                    )
                    .padding(EdgeInsets(top: 0, leading: 30, bottom: 5, trailing: 30))
            }
            
            Spacer()
            VStack(){
                /*
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
                }*/
                HStack(){
                    //Spacer()
                  
                       
                            ZStack(){
                                
                                RoundedRectangle(cornerRadius: 4.0)
                                    .foregroundColor(ColorPallete().lightFGColor)
                                    .frame(width: 140, height: 80, alignment: .center)
                                Text("Register")
                                
                                    .foregroundColor(ColorPallete().lightBGColor)
                                    .font(Font.custom(appFontMainRegular,size:15))
                            }
                            .sheet(isPresented: $showRegister) {
                                SignUpView()
                                
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
                    
                    //.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30))
                    
                }
            }
            Spacer()
                .frame(maxHeight: 30)
            
        }
        .background(ColorPallete().mediumFGColor)
        
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

