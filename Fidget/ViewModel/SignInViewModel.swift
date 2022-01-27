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
        self.signedIn = auth.currentUser != nil
        return self.signedIn
    }
    
    func signInUser(_ email: String, _ password: String){
        
        auth.signIn(withEmail: email, password: password){ [weak self] result, error in
            guard result != nil, error == nil else{
                print("Sign In Failed with Firebase")
                return
            }
            
            DispatchQueue.main.async {
                //Successful sign in
                self?.signedIn = true
            }
            
            
        }
    }
    
    func signOutUser(){
        try? auth.signOut()
        self.signedIn = false
    }
    
    
}
