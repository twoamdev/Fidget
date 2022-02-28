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
    @StateObject var usernameTextObserver = TextFieldObserver(delay: 0.5)
    @StateObject var emailTextObserver = TextFieldObserver(delay: 0.5)
    @State var showUsernameFields : Bool = false
    @State var showPasswordFields : Bool = false
    @State var showCreateUserLoadScreen : Bool = false
    
    var body: some View {
        VStack{
            nameFields
        }
    }
    
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
                    .onChange(of: signUpVM.userInput.firstName) { firstName in
                        signUpVM.validateFirstName(firstName)
                    }
                StandardTextField("Last Name", $signUpVM.userInput.lastName, verifier: $signUpVM.userInput.lastNameIsValid).normalWithVerify
                    .padding(.horizontal)
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
        
    }
    
    var usernameAndEmailFields : some View {
       
            VStack{
                NavigationLink(destination: passwordFields, isActive: $showPasswordFields){
                    EmptyView()
                }
                .navigationBarTitle("", displayMode: .inline)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text("Profile")
                            .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.navTitleFieldSize))
                    }
                }
               
                Spacer()
                VStack(alignment: .leading){
                    StandardTextField("Username", $usernameTextObserver.searchText, verifier: $signUpVM.userInput.usernameIsValid, loading: $signUpVM.userInput.usernameLoading).normalWithVerify
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .padding(.horizontal)
                        .onReceive(usernameTextObserver.$debouncedText) { username in
                            signUpVM.userInput.username = username
                            signUpVM.validateUsername(username)
                        }
                        .onChange(of: usernameTextObserver.searchText, perform:{ _ in
                            signUpVM.userInput.usernameIsLoading()
                        })
                    StandardUserTextHelper(message: "Username must be 3-18 characters.", indicator: $signUpVM.userInput.usernameLengthIsValid)
                        .padding(.horizontal)
                    StandardUserTextHelper(message: "Only letters, numbers, and underscores.", indicator: $signUpVM.userInput.usernameCharsAreValid)
                        .padding(.horizontal)
                    StandardUserTextHelper(message: "Not claimed by another user.", indicator: $signUpVM.userInput.usernameIsValid)
                        .padding(.horizontal)
                }
                    
                
                StandardTextField("Email Address", $emailTextObserver.searchText, verifier: $signUpVM.userInput.emailIsValid, loading: $signUpVM.userInput.emailLoading).normalWithVerify
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                    .onReceive(emailTextObserver.$debouncedText) { email in
                        signUpVM.userInput.email = email
                        signUpVM.validateEmailAddress(email)
                    }
                    .onChange(of: emailTextObserver.searchText, perform:{ _ in
                        signUpVM.userInput.emailIsLoading()
                    })
                StandardButton(label: "CONTINUE") {
                    showPasswordFields.toggle()
                }
                .padding()
                .disabled(!(signUpVM.userInput.emailIsValid && signUpVM.userInput.usernameIsValid))
                Spacer()
                Spacer()
            }
        
    }
    
    
    var passwordFields : some View {
        VStack{
            Spacer()
            VStack(alignment: .leading){
                StandardTextField("Password", $signUpVM.userInput.password, verifier: $signUpVM.userInput.passwordIsValid).normalWithVerify
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                    .padding(.horizontal)
                    .onChange(of: signUpVM.userInput.password) { password in
                        signUpVM.validatePassword(password)
                    }
                StandardUserTextHelper(message: "Must have at least 8 characters.", indicator: $signUpVM.userInput.passwordHasEnoughChars)
                    .padding(.horizontal)
                StandardUserTextHelper(message: "Has 1 upper and 1 lowercase letter.", indicator: $signUpVM.userInput.passwordHasUpperAndLower)
                    .padding(.horizontal)
                StandardUserTextHelper(message: "Has at least 1 number.", indicator: $signUpVM.userInput.passwordHasNumber)
                    .padding(.horizontal)
            }
            StandardTextField("Confirm Password", $signUpVM.userInput.confirmPassword, verifier: $signUpVM.userInput.passwordConfirmIsValid).normalWithVerify
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .padding(.horizontal)
                .onChange(of: signUpVM.userInput.confirmPassword) { confirm in
                    signUpVM.validateConfirmationPassword(confirm)
                }
            
            StandardButton(label: "CREATE ACCOUNT") {
                showOnboarding = false
                signUpVM.signUpUser()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation{
                        signUpVM.userSignUpStatus.dispatchIsLoading = false
                    }
                }
            }
            .padding()
            .disabled(!signUpVM.userInput.allAreValid())
            Spacer()
            Spacer()
            
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Password")
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
