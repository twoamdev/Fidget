//
//  ProfileViewModel.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/2/22.
//

import SwiftUI
import Firebase


@MainActor class ProfileViewModel : ObservableObject{
    @Published var profile : User = User(String(), String(), String(), String())
    @Published var loadingProfile : Bool = false
    private var profileDataExists : Bool = false
    
    
    func signOut(){
        try? Auth.auth().signOut()
    }
    
    func fetchProfile(){
        if !profileDataExists {
            if let uid = Auth.auth().currentUser?.uid{
                let userUtils = ProfileUtils()
                Task{
                    do{
                        self.loadingProfile = true
                        try await userUtils.fetchUserSharedInfo(uid, completion: { (data) in
                            if data != nil{
                                let sharedData : User.SharedData = data!
                                self.profile.sharedInfo = sharedData
                            }
                        })
                        try await userUtils.fetchUserPrivateInfo(uid, completion: { (data) in
                            if data != nil{
                                let privateData : User.PrivateData = data!
                                self.profile.privateInfo = privateData
                            }
                        })
                        self.profileDataExists = true
                        self.loadingProfile = false
                    }
                    catch{
                        print("Error Fetching Profile: \(error)")
                    }
                }
            }
            else{
                print("No user logged in, fetching user data is not possible")
            }
        }
    }




}


