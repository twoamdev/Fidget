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
    private var homeVM : HomeViewModel?
    
    @Published var signInLoading = false
    
    @Published var showHome : Bool = false
    @Published var inputEmail = String()
    @Published var inputPassword = String()
    
    @Published var emailErrorMessage = String()
    @Published var passwordErrorMessage = String()
    
    @Published var validEmail = true //false  **** only for debug
    @Published var validPassword = true //false  **** only for debug
    
    func signInUser(_ homeViewModel : HomeViewModel){
        self.signInLoading.toggle()
        self.homeVM = homeViewModel
        self.signInViaFirebase()
    }
    
    private func signInViaFirebase(){
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
                        self?.signInLoading.toggle()
                    case .wrongPassword:
                        self?.emailErrorMessage = String()
                        self?.passwordErrorMessage = "Incorrect Password"
                        self?.signInLoading.toggle()
                    default:
                        self?.signInLoading.toggle()
                        break
                    }
                }
                return
            }
            
            DispatchQueue.main.async {
                //Successful sign in
                if (self?.auth.currentUser != nil){
                    self?.clearUserInputs()
                    self?.showHome = true
                    self?.signInLoading.toggle()
                    self?.homeVM?.loadUserProfileAndBudget(loadingAfterUserSignIn: true)
                }
                else{
                    self?.signInLoading.toggle()
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

