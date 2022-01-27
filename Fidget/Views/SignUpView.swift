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
    @Binding var showRegister : Bool
    @EnvironmentObject var signUpViewModel : SignUpViewModel
    @State private var userInput = SignUpUserInput()

    var body: some View {
        VStack(){
            Spacer()
            TextFieldView(label: "First Name", userInput: $userInput.firstName).standardTextField
            TextFieldView(label: "Last Name", userInput: $userInput.lastName).standardTextField
            TextFieldView(label: "Email", userInput: $userInput.email).standardTextField
            TextFieldView(label: "Password", userInput: $userInput.password).standardTextField
            TextFieldView(label: "Confirm Password", userInput: $userInput.confirmPassword).standardTextField
            Spacer()
            Button(action: {
                //add a user
                let result : (Bool,String) = signUpViewModel.signUpUser(userInput)
                if result.0 {
                    showRegister.toggle()
                }
                else{
                    print(result.1)
                }
                
                
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


