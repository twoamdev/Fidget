//
//  UserDataUtils.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/21/22.
//

import SwiftUI
import Firebase

@MainActor class UserDataUtils {
    private var db = Firestore.firestore()
    static let noUserFound = "NO_USER_FOUND"
    
    func fetchUserSharedInfo(_ userId : String, completion: @escaping (User.SharedData?) -> Void) async throws{
        let snapshot = try await self.db.collection(DbCollectionA.sharedData).document(userId).getDocument()
        let data = try snapshot.data(as: User.SharedData.self)
        completion(data)
    }
    
    func fetchUserPrivateInfo(_ userId : String, completion: @escaping (User.PrivateData?) -> Void) async throws{
        let snapshot = try await self.db.collection(DbCollectionA.users).document(userId).getDocument()
        let data = try snapshot.data(as: User.PrivateData.self)
        completion(data)
    }
    
}

