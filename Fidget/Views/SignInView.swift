//
//  LoginView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI


struct SignInView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @State var userSignedOut : Bool
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showSignUpPage = false
    @State private var showSignUpToast = false
    
    
    
    
    let appFontMainRegular = AppFonts().mainFontBold
    var body: some View {
        ZStack(){
            VStack{
                Spacer()
                VStack(){
                    
                    
                    Text("PIGG")
                        .tracking(-2.0)
                        .font(Font.custom(appFontMainRegular,size: 50))
                        .foregroundColor(ColorPallete().mediumBGColor)
                    
                    TextFieldView(label: "Email Address",userInput: $username).standardTextField
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    TextFieldView(label: "Password", userInput: $password).secureTextField
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
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
                    .sheet(isPresented: $showSignUpPage) {
                        SignUpView(showSignUpPage: $showSignUpPage, showSignUpToast: $showSignUpToast)
                        
                    }
                    .onTapGesture{
                        showSignUpPage.toggle()
                    }
                    
                    
                    
                    Button(action: {
                        signInViewModel.signInUser(username, password)
                        
                        
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
            VStack(){
                if showSignUpToast{
                    ToastView(message:"Signed Up Successfully" ,show: $showSignUpToast)
                    
                }
                if userSignedOut {
                    ToastView(message:"User Signed Out" ,show: $userSignedOut)
                }
                Spacer()
            }
            
        }
        
    }
    
}

/*
 struct LoginView_Previews: PreviewProvider {
 static var previews: some View {
 LoginView()
 }
 }
 
 */
