//
//  ProfileViewModel.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/2/22.
//

import SwiftUI
import Firebase


class ProfileViewModel{
    @Published var profile : Profile = Profile()
    
    init(){
        fetchProfile()
    }
    
    func fetchProfile (){
        
        let db = Firestore.firestore()
        let auth = Auth.auth()
        
        
        if let uid = auth.currentUser?.uid{
            let document = db
                .collection(DatabaseCollections().users)
                .document(uid)
                .collection(DatabaseCollections().userData)
                .document(DatabaseDocs().personalInfo)
            
            document.getDocument { (snapshot, err) in
                guard let snapshot = snapshot else {
                    print("Error \(err!)")
                    return
                }

                let firstName = snapshot.get(DatabaseFields().firstName) as! String
                let lastName = snapshot.get(DatabaseFields().lastName) as! String
                let username = snapshot.get(DatabaseFields().username) as! String
                let emailAddress = snapshot.get(DatabaseFields().emailAddress) as! String
                self.profile = Profile(firstName,lastName,username,emailAddress)
            }
        }
    }
}


