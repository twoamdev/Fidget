//
//  LoginView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI


struct SignInView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @EnvironmentObject var homeVM : HomeViewModel
    @State private var showPassword : Bool = false
    
    var body: some View {
        VStack(){
            Spacer()
            Text("Nice to see you back.")
                .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                .kerning(AppFonts.titleKerning)
                .padding(.horizontal)
            Spacer()
            StandardTextField("Email Address", $signInViewModel.inputEmail, verifier: $signInViewModel.validEmail, errorMessage: $signInViewModel.emailErrorMessage).normalWithVerify
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .submitLabel(.done)
                .padding(.horizontal)
                .onChange(of: signInViewModel.inputEmail, perform:{ inputEmail in
                    signInViewModel.validateEmailAddress(inputEmail)
                })
            StandardTextField("Password", $signInViewModel.inputPassword,
                              verifier: $signInViewModel.validPassword,
                              errorMessage: $signInViewModel.passwordErrorMessage,
                              showPassword: $showPassword).normalSecureWithVerify
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .submitLabel(.done)
                .padding(.horizontal)
                .onChange(of: signInViewModel.inputPassword, perform:{ inputPassword in
                    signInViewModel.validatePassword(inputPassword)
                })
            
            StandardButton(label: "SIGN IN") {
                signInViewModel.signInUser(homeVM)
            }
            .padding()
            .disabled(!(signInViewModel.validEmail && signInViewModel.validPassword))
            
            Spacer()
            Spacer()
        }
        
    }
    
}

/*
struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}
*/

