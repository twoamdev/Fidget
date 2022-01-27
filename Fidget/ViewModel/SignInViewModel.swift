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
    @Published var signedIn : Bool = false
    
    var isSignedIn: Bool{
        return auth.currentUser != nil
    }
    
    func signInUser(_ email: String, _ password: String){
        print("Attempting sign in for: \(email) and their password: \(password)")
        
        auth.signIn(withEmail: email, password: password){ [weak self] result, error in
            guard result != nil, error == nil else{
                print("Sign In Failed with Firebase")
                return
            }
            
            DispatchQueue.main.async {
                //Successful sign up
                print("SIGNED IN: \(email)")
                self?.signedIn = true
                print("sign in bool: \(self!.signedIn)")
                
            }
            
        }
    }
    
    func signOutUser(){
        try? auth.signOut()
        self.signedIn = false
    }
    
    
}
