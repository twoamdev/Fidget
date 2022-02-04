//
//  SignUpView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/22/22.
//

import SwiftUI

struct SignUpUserInput{
    var firstName : String = ""
    var lastName : String = ""
    var email : String = ""
    var password : String = ""
    var confirmPassword : String = ""
    
}


struct SignUpView: View {
    @Binding var showSignUpPage : Bool
    @EnvironmentObject var signUpViewModel: SignUpViewModel
    @State private var userInput = SignUpUserInput()

    var body: some View {
        
        VStack(){
            Spacer()
            
            TextFieldView(label: "First Name", userInput: $userInput.firstName, errorMessage: signUpViewModel.firstNameErrorMessage).standardTextField
                .animation(.easeInOut)
            TextFieldView(label: "Last Name", userInput: $userInput.lastName, errorMessage: signUpViewModel.lastNameErrorMessage).standardTextField
                .animation(.easeInOut)
            TextFieldView(label: "Email", userInput: $userInput.email, errorMessage: signUpViewModel.emailErrorMessage).standardTextField
                .animation(.easeInOut)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            TextFieldView(label: "Password", userInput: $userInput.password, errorMessage: signUpViewModel.passwordErrorMessage).standardTextField
                .animation(.easeInOut)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            TextFieldView(label: "Confirm Password", userInput: $userInput.confirmPassword, errorMessage: signUpViewModel.confirmPasswordErrorMessage).standardTextField
                .animation(.easeInOut)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            Spacer()
            /*
            if signUpViewModel.signUpSuccess {
                showSignUpPage.toggle()
                showSignUpToast.toggle()
            }
            */
            Button(action: {
                signUpViewModel.signUpUser(userInput)
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
        SignUpView(showSignUpPage: .constant(true), showSignUpToast: .constant(true))
    }
}

*/
