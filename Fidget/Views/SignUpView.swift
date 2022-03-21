//
//  SignUpView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/22/22.
//

import SwiftUI

struct SignUpView: View {
    @Binding var showOnboarding : Bool
    @EnvironmentObject var signUpVM : SignUpViewModel
    @EnvironmentObject var homeVM : HomeViewModel
   // @StateObject var usernameTextObserver = TextFieldObserver(delay: 0.5)
    @StateObject var emailTextObserver = TextFieldObserver(delay: 0.5)
    
    var body: some View {
        VStack{
            passwordFields
        }
    }
    
    /*
    var nameFields : some View{
            VStack{
                NavigationLink(destination: usernameAndEmailFields, isActive: $showUsernameFields){
                    EmptyView()
                }
                .navigationBarTitle("", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Name")
                            .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.navTitleFieldSize))
                    }
                }
                
                Spacer()
                StandardTextField("First Name", $signUpVM.userInput.firstName, verifier: $signUpVM.userInput.firstNameIsValid).normalWithVerify
                    .padding(.horizontal)
                    .submitLabel(.done)
                    .onChange(of: signUpVM.userInput.firstName) { firstName in
                        signUpVM.validateFirstName(firstName)
                    }
                StandardTextField("Last Name", $signUpVM.userInput.lastName, verifier: $signUpVM.userInput.lastNameIsValid).normalWithVerify
                    .padding(.horizontal)
                    .submitLabel(.done)
                    .onChange(of: signUpVM.userInput.lastName) { lastName in
                        signUpVM.validateLastName(lastName)
                    }
                StandardButton(label: "CONTINUE") {
                    showUsernameFields.toggle()
                }
                .padding()
                .disabled(!(signUpVM.userInput.firstNameIsValid && signUpVM.userInput.lastNameIsValid))
                Spacer()
                Spacer()
            }
        
    }*/
    
    
    
    var passwordFields : some View {
        VStack{
            Spacer()
            Text("Create Account")
                .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                .kerning(AppFonts.titleKerning)
                .padding(.horizontal)
            Spacer()
            VStack(alignment: .leading){
                StandardTextField(label: "Email Address", text: $emailTextObserver.searchText, verifier: $signUpVM.userInput.emailIsValid, loading: $signUpVM.userInput.emailLoading).normalWithVerify
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .submitLabel(.done)
                    .padding(.horizontal)
                    .onReceive(emailTextObserver.$debouncedText) { email in
                        signUpVM.userInput.email = email
                        signUpVM.validateEmailAddress(email)
                    }
                    .onChange(of: emailTextObserver.searchText, perform:{ _ in
                        signUpVM.userInput.emailIsLoading()
                    })
                
                StandardTextField(label: "Password", text: $signUpVM.userInput.password, verifier: $signUpVM.userInput.passwordIsValid).normalWithVerify
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .submitLabel(.done)
                    .padding(.horizontal)
                    .onChange(of: signUpVM.userInput.password) { password in
                        signUpVM.validatePassword(password)
                    }
                
                StandardUserTextHelper(message: "Requires at least 8 characters.", indicator: $signUpVM.userInput.passwordHasEnoughChars)
                    .padding(.horizontal)
                StandardUserTextHelper(message: "Requires 1 upper and 1 lowercase letter.", indicator: $signUpVM.userInput.passwordHasUpperAndLower)
                    .padding(.horizontal)
                StandardUserTextHelper(message: "Requires at least 1 number.", indicator: $signUpVM.userInput.passwordHasNumber)
                    .padding(.horizontal)
                StandardUserTextHelper(message: "Optional special characters.", indicator: $signUpVM.userInput.passwordHasValidOptionalSpecialChars)
                    .padding(.horizontal)
            }

            
            StandardButton(label: "CREATE ACCOUNT") {
                signUpVM.signUpUser(showOnboarding : $showOnboarding, homeVM)
            }
            .padding()
            .disabled(!signUpVM.userInput.allAreValid())
            Spacer()
            Spacer()
            
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("")
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.navTitleFieldSize))
            }
        }        
    }
}





/*
 struct SignUpView_Previews: PreviewProvider {
 static var previews: some View {
 SignUpView()
 
 }
 }
 
 */
