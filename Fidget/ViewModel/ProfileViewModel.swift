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
            let document = db.collection("users").document(uid)
            document.getDocument { (snapshot, err) in
                guard let snapshot = snapshot else {
                    print("Error \(err!)")
                    return
                }

                let firstName = snapshot.get(ProfileLabels().firstName) as! String
                let lastName = snapshot.get(ProfileLabels().lastName) as! String
                let username = snapshot.get(ProfileLabels().username) as! String
                let emailAddress = snapshot.get(ProfileLabels().emailAddress) as! String
                self.profile = Profile(firstName,lastName,username,emailAddress)
            }
        }
    }
}


