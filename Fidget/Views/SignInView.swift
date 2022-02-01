//
//  LoginView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI


struct SignInView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var showSignUpPage = false
    @State private var showSignUpToast = false
    @State var showSignOutToast = false
    
    
    
    
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
                    
                    TextFieldView(label: "Email Address",userInput: $username, errorMessage: signInViewModel.emailErrorMessage).standardTextField
                        .animation(.easeInOut)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    TextFieldView(label: "Password", userInput: $password, errorMessage: signInViewModel.passwordErrorMessage).secureTextField
                        .animation(.easeInOut)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                    ZStack(){
                        /*
                        RoundedRectangle(cornerRadius: 4.0)
                            .foregroundColor(ColorPallete().lightFGColor)
                            .frame( height: 40, alignment: .center)
                         */
                        Text("SIGN UP WITH EMAIL")
                        
                            .foregroundColor(ColorPallete().lightBGColor)
                            .font(Font.custom(appFontMainRegular,size:15))
                    }
                    .sheet(isPresented: $showSignUpPage) {
                        SignUpView(showSignUpPage: $showSignUpPage, showSignUpToast: $showSignUpToast)
                        
                    }
                    .onTapGesture{
                        showSignUpPage.toggle()
                    }
                     
                }
                
                Spacer()
                
                VStack(){
                    
                    ZStack(){
                        
                        RoundedRectangle(cornerRadius: 4.0)
                            .foregroundColor(ColorPallete().lightFGColor)
                            .frame( height: 40, alignment: .center)
                        Text("Sign In")
                        
                            .foregroundColor(ColorPallete().lightBGColor)
                            .font(Font.custom(appFontMainRegular,size:15))
                    }
                    .padding(.horizontal)
                    .padding(.horizontal)
                    .fullScreenCover(isPresented: $signInViewModel.signedIn) {
                        TabBarMainView()
                            .environmentObject(signInViewModel)
                        
                    }
                    .onTapGesture{
                        signInViewModel.signInUser(username, password)
                    }
                }
                
                Spacer()
                .frame(maxHeight: 30)
                
            }
            .background(ColorPallete().mediumFGColor)
            VStack(){
                if showSignUpToast{
                    ToastView(message:"Signed Up Successfully" ,show: $showSignUpToast)
                    
                }
                if signInViewModel.userSignedOut {
                    ToastView(message:"User Signed Out" ,show: $signInViewModel.userSignedOut)
                }
                Spacer()
            }
            
            
        }

        
    }
    
}


