//
//  ProfileViewModel.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/2/22.
//

import SwiftUI
import Firebase

class ProfileViewModel : ObservableObject {
    
    private let db = Firestore.firestore()
    
    @Published var firstName : String
    @Published var lastName : String
    @Published var emailAddress : String
    @Published var userName : String
    @Published var loading : Bool
    
    init(){
        self.firstName = ""
        self.lastName = ""
        self.emailAddress = ""
        self.userName = ""
        self.loading = false
        loadProfile()
    }
    
    func loadProfile(){
        print("calling LOADPROFILE")
        if let uid = Auth.auth().currentUser?.uid{
            let document = db.collection("userProfiles").document(uid)
            
            document.getDocument { (snapshot, err) in
                if let err = err{
                    print("Error loading profile: \(err)")
                }
                else{
                    self.firstName = snapshot?.get("firstName") as! String
                    self.lastName = snapshot?.get("lastName") as! String
                    self.emailAddress = snapshot?.get("emailAddress") as! String
                    self.userName = snapshot?.get("username") as! String
                    self.loading = false
                    print("done")
                }
            }
        }
    }
    
}


