//
//  SignInViewModel.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/26/22.
//

import SwiftUI
import FirebaseAuth

class SignInViewModel : ObservableObject{
    private let auth = Auth.auth()
    private var signInErrorMessages = SignInErrorMessage()
    
    @Published var showHome : Bool = false
    @Published var inputEmail = String()
    @Published var inputPassword = String()
    
    @Published var emailErrorMessage = String()
    @Published var passwordErrorMessage = String()
    
    @Published var validEmail = false
    @Published var validPassword = false
    
    @Published var isSigningIn = false
    
    
    
    
    
    
    func signInUser(){
        
        self.isSigningIn = true
        self.signInViaFirebase()
        
    }
    
    func signInViaFirebase(){
        let email = self.inputEmail
        let password = self.inputPassword
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        auth.signIn(withEmail: trimmedEmail, password: password){ [weak self] result, error in
            guard result != nil, error == nil else{
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    switch errorCode{
                    case .userNotFound:
                        self?.emailErrorMessage = self?.signInErrorMessages.getMessage() ?? "That email isn't found"
                        self?.passwordErrorMessage = String()
                    case .wrongPassword:
                        self?.emailErrorMessage = String()
                        self?.passwordErrorMessage = "Wrong password"
                    default:
                        break
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                //Successful sign in
                if (self?.auth.currentUser != nil){
                    self?.clearUserInputs()
                    self?.isSigningIn = false
                    print("user signed in")
                    self?.showHome = true
                }
                else{
                    print("user not signed in")
                }
            }
        }
    }
    
    @MainActor func validateEmailAddress(_ email : String){
        self.validEmail = ValidationUtils().validateEmailAddressFormat(email)
    }
    
    @MainActor func validatePassword(_ password : String){
        self.validPassword = ValidationUtils().validatePasswordFormat(password)
    }
    
    func clearUserInputs(){
        self.inputEmail = String()
        self.inputPassword = String()
        self.validEmail = false
        self.validPassword = false
        self.emailErrorMessage = String()
        self.passwordErrorMessage = String()
    }
}

struct SignInErrorMessage {
    private let messages = ["That email isn't registered with an account.",
                            "The email you typed isn't registered.",
                            "Nope, that email isn't registering."]
    private var counter = 0
    
    mutating func getMessage() -> String{
        let modCount = messages.count
        self.counter += 1
        if self.counter > 100000{
            self.counter = 0
        }
        let index = self.counter % modCount
        return self.messages[index]
    }
    
    
}

