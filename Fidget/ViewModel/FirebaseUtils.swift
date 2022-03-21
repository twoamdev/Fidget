//
//  FirebaseUtils.swift
//  Fidget
//
//  Created by Ben Nelson on 3/12/22.
//

import SwiftUI
import Firebase

class FirebaseUtils {
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    static let noUserFound = "NO_USER_FOUND"
    
    func getCurrentUid() -> String {
        if let uid = auth.currentUser?.uid{
            return uid
        }
        else{
            return FirebaseUtils.noUserFound
        }
    }
    
    func signOut(){
        try? Auth.auth().signOut()
    }
    
    func updateUserSharedInfo(_ userId : String, _ sharedData : User.SharedData,  completion: @escaping (Bool) -> Void){
        do{
            try self.db.collection(DbCollectionA.sharedData).document(userId).setData(from: sharedData)
            print("UPDATED shared user data")
            completion(true)
        }
        catch{
            print("error in updating shared user data: \(error)")
            completion(false)
        }
    }
    
    func updatePublicUsernames(_ username : String, _ existingUsername : String, completion: @escaping (Bool) -> Void){
        if !existingUsername.isEmpty{
            deletePublicUsername(existingUsername, completion: { result in
                if result {
                    print("existing username deleted")
                }
            })
        }
        
        self.db.collection(DbCollectionA.publicUsernames).document(username).setData([:])
        completion(true)
    }
    
    @MainActor func fetchUserSharedData(_ userId : String, completion: @escaping (User.SharedData?) -> Void) async throws{
        let snapshot = try await self.db.collection(DbCollectionA.sharedData).document(userId).getDocument()
        if snapshot.exists{
            let data = try snapshot.data(as: User.SharedData.self)
            completion(data)
        }
        else{
            completion(nil)
        }
    }
    
    @MainActor func fetchUserPrivateData(_ userId : String, completion: @escaping (User.PrivateData?) -> Void) async throws{
        let snapshot = try await self.db.collection(DbCollectionA.users).document(userId).getDocument()
        if snapshot.exists{
            let data = try snapshot.data(as: User.PrivateData.self)
            completion(data)
        }
        else{
            completion(nil)
        }
    }
    
    func deletePublicUsername( _ username : String, completion: @escaping (Bool) -> Void){
        self.db.collection(DbCollectionA.publicUsernames).document(username).delete() { err in
            if let err = err {
                print("Error removing username: \(err)")
                completion(false)
            } else {
                print("Username successfully removed!")
                completion(true)
            }
        }
    }
    
    func deletePublicEmail(_ email : String, completion: @escaping (Bool) -> Void){
        self.db.collection(DbCollectionA.publicEmails).document(email).delete() { err in
            if let err = err {
                print("Error removing email: \(err)")
                completion(false)
            } else {
                print("Email successfully removed!")
                completion(true)
            }
        }
    }
    
    func fetchBudget(_ budgetId : String, completion: @escaping (Budget?) -> Void){
        let docRef = self.db.collection(DbCollectionA.budgets).document(budgetId)
        
        docRef.getDocument(as: Budget.self, completion: { snapshot in
            do{
                let budget : Budget = try snapshot.get()
                print("fetching budget")
                completion(budget)
            }
            catch{
                print("error fetching budget")
                completion(nil)
            }
        })
    }
    
    func updateBudget(_ budget : Budget, _ referenceId : String, completion: @escaping (Bool) -> Void){
        do{
            try self.db.collection(DbCollectionA.budgets).document(referenceId).setData(from: budget)
            print("UPDATED Budget with new users list: \(budget.linkedUserIds)")
            completion(true)
        }
        catch{
            print("error in updating budget: \(error)")
            completion(false)
        }
    }
    
    func deleteBudget(_ referenceId : String, completion: @escaping (Bool) -> Void){
        self.db.collection(DbCollectionA.budgets).document(referenceId).delete() { err in
            if let err = err {
                print("Error removing budget: \(err)")
                completion(false)
            } else {
                print("Budget successfully removed!")
                completion(true)
            }
        }
    }
    
    
    func deletePrivateUserData(_ userId : String, completion: @escaping (Bool) -> Void){
        self.db.collection(DbCollectionA.users).document(userId).delete() { err in
            if let err = err {
                print("Error removing private data: \(err)")
                completion(false)
            } else {
                print("Private Data successfully removed!")
                completion(true)
            }
        }
    }
    
    func deleteSharedUserData(_ userId : String, completion: @escaping (Bool) -> Void){
        self.db.collection(DbCollectionA.sharedData).document(userId).delete() { err in
            if let err = err {
                print("Error removing shared data: \(err)")
                completion(false)
            } else {
                print("Shared Data successfully removed!")
                completion(true)
            }
        }
    }
    
    func deleteUser(completion: @escaping (Bool) -> Void){
        let user = Auth.auth().currentUser

        user?.delete { error in
          if let error = error {
            // An error happened.
              print("error deleting user: \(error)")
              completion(false)
          } else {
            // Account deleted.
              print("User successfully deleted")
              completion(true)
          }
        }
    }
}
