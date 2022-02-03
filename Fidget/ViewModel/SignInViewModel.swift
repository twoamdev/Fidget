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
    private var userSignInMessage : String = ""
    
    
    init(){
        self.signedIn = false
        self.userSignedOut = false
        self.emailErrorMessage = ""
        self.passwordErrorMessage = ""
        self.userId = ""
    }

    
    var isSignedIn: Bool{
        self.signedIn = auth.currentUser != nil
        return self.signedIn
    }
    
    
    func signInUser(_ email: String, _ password: String){
        
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
                self?.signedIn = true
                self?.userSignedOut = false
                self?.userId = (self?.auth.currentUser!.uid)!
            }
        }
    }
    
    
    
    func signOutUser(){
        try? auth.signOut()
        self.signedIn = false
        self.userSignedOut = true
        self.userId = ""
    }
}
