//
//  LoginView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI


struct SignInView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @ObservedObject private var signUpViewModel : SignUpViewModel = SignUpViewModel()
    private let boxPadding = EdgeInsets(top: 0, leading: 30, bottom: 5, trailing: 30)
    let appFontMainRegular = AppFonts().mainFontBold
    var body: some View {

        ZStack(){
            VStack{
                Spacer()
                VStack(){
                    
                    
                    Text("PIG")
                        .tracking(-2.0)
                        .font(Font.custom(appFontMainRegular,size: 50))
                        .foregroundColor(ColorPallete().mediumBGColor)
                    
                    TextFieldView(label: "Email Address",userInput: $signInViewModel.inputUsername, errorMessage: signInViewModel.emailErrorMessage).standardTextField
                        .padding(boxPadding)
                        .animation(.easeInOut)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    TextFieldView(label: "Password", userInput: $signInViewModel.inputPassword, errorMessage: signInViewModel.passwordErrorMessage).secureTextField
                        .padding(boxPadding)
                        .animation(.easeInOut)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                    
                    ZStack(){
                        Text("SIGN UP WITH EMAIL")
                        
                            .foregroundColor(ColorPallete().lightBGColor)
                            .font(Font.custom(appFontMainRegular,size:15))
                    }
                    .sheet(isPresented: $signUpViewModel.showSignUpPage) {
                        SignUpView(showSignUpPage: $signUpViewModel.showSignUpPage)
                            .environmentObject(signUpViewModel)
                        
                    }
                    .onTapGesture{
                        signUpViewModel.showSignUpPage.toggle()
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
                        HomeView()
                            .environmentObject(signInViewModel)
                    }
                    .onTapGesture{
                        signInViewModel.signInUser()
                    }
                }
                
                Spacer()
                .frame(maxHeight: 30)
                
            }
            .background(ColorPallete().mediumFGColor)
            VStack(){
                if signUpViewModel.signUpSuccess{
                    ToastView(message:"Signed Up Successfully" ,show: $signUpViewModel.signUpSuccess)
                    
                }
                if signInViewModel.userSignedOut {
                    ToastView(message:"User Signed Out" ,show: $signInViewModel.userSignedOut)
                }
                Spacer()
            }
            
            
        }

        
    }
    
}


