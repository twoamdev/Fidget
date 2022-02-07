//
//  SignInViewModel.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/26/22.
//

import SwiftUI
import FirebaseAuth

class SignInViewModel : ObservableObject{
    let auth = Auth.auth()
    @Published var signedIn : Bool
    @Published var userSignedOut : Bool
    @Published var emailErrorMessage : String
    @Published var passwordErrorMessage : String
    @Published var userId : String
    @Published var inputUsername : String
    @Published var inputPassword : String
    private var userSignInMessage : String = ""
    
    
    init(){
        self.signedIn = false
        self.userSignedOut = false
        self.emailErrorMessage = ""
        self.passwordErrorMessage = ""
        self.userId = ""
        self.inputUsername = "twoamdev@gmail.com"                        //CHANGE AFTER TESTING to ""
        self.inputPassword = "HelloWorld2022"                         //CHANGE AFTER TESTING to ""
    }


    func clearInput(){
        self.inputUsername = ""
        self.inputPassword = ""
    }
    
    func signInUser(){
        let email = self.inputUsername
        let password = self.inputPassword
        
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        if !AuthenticationUtils().isValidEmailAddress(trimmedEmail){
            self.emailErrorMessage = "Enter a valid email address"
            return
        }
        else{
            self.emailErrorMessage = ""
        }
        
        auth.signIn(withEmail: trimmedEmail, password: password){ [weak self] result, error in
            guard result != nil, error == nil else{
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    switch errorCode{
                    case .userNotFound:
                        self?.emailErrorMessage = "User Not Found"
                    case .wrongPassword:
                        self?.passwordErrorMessage = AuthenticationUtils().isValidPassword(password) ? "Wrong Password" : "Password is invalid"
                    default:
                        break
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                //Successful sign in
                self?.emailErrorMessage = ""
                self?.passwordErrorMessage = ""
                self?.signedIn = self?.auth.currentUser != nil
                self?.userSignedOut = false
                self?.userId = (self?.auth.currentUser!.uid)!
                self?.inputUsername = ""
                self?.inputPassword = ""
            }
        }
    }
    
    
    func signOutUser(){
        try? auth.signOut()
        self.signedIn = auth.currentUser != nil
        self.userSignedOut = true
        self.userId = ""
    }
}
