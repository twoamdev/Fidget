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
    
    func loadProfile() {
        if let uid = Auth.auth().currentUser?.uid{
            self.loading = true
            print("USER ID: \(uid)")
            db.collection("userProfiles").getDocuments { (snapshot, err) in
                   if let err = err {
                       print("Error getting documents: \(err)")
                   } else {
                       
                           for document in snapshot!.documents {
                              let docId = document.documentID
                               if docId == uid{
                                   self.firstName = document.get("firstName") as! String
                                   self.lastName = document.get("lastName") as! String
                                   self.emailAddress = document.get("emailAddress") as! String
                                   self.userName = document.get("username") as! String
                                   self.loading = false
                                   break
                               }
                           }
                       
                   }
            }
        }
    }
    
}


