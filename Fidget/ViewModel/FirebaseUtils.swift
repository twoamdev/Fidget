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
    static let noUserFound = "deleted user"
    static let isCurrentUser = "me"
    static let uidFieldKey = "uid"
    static let invitesFieldKey = "invites"
    static let archivedBudgets = "archivedBudgets"
    
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
    
    
    func updateUserPrivateInfo(_ privateData : User.PrivateData,  completion: @escaping (Bool) -> Void){
        do{
            let userId = self.getCurrentUid()
            try self.db.collection(DBCollectionLabels.users).document(userId).setData(from: privateData)
            print("UPDATED private user data")
            completion(true)
        }
        catch{
            print("error in updating private user data: \(error)")
            completion(false)
        }
    }
    
    func updateUserSharedInfo(_ userId : String, _ sharedData : User.SharedData,  completion: @escaping (Bool) -> Void){
        do{
            try self.db.collection(DBCollectionLabels.sharedData).document(userId).setData(from: sharedData)
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
        
        let uid = self.getCurrentUid()
        let data = [FirebaseUtils.uidFieldKey : uid]
        self.db.collection(DBCollectionLabels.publicUsernames).document(username).setData(data)
        completion(true)
    }
    
    func fetchUidFromUsername(_ username : String, completion: @escaping (String) -> Void){
        self.db.collection(DBCollectionLabels.publicUsernames).document(username).getDocument(completion: { snapshot, error in
            if error != nil {
                print(error!.localizedDescription)
                completion(String())
            }
            else{
                let data = snapshot?.data()
                let converted = data?.compactMapValues { $0 as? String } ?? [:]
                let uid : String? = converted[FirebaseUtils.uidFieldKey]
                completion(uid ?? String())
            }
            
        })
    }
    
    func replaceBudgetInvitations(_ replacementInvites : [Invitation], completion: @escaping (Bool) -> Void){
        let uid = self.getCurrentUid()
        
        let replacement = [FirebaseUtils.invitesFieldKey : replacementInvites]
        do{
            try self.db.collection(DBCollectionLabels.invites).document(uid).setData(from: replacement)
            completion(true)
        }
        catch{
            print("error replacing budget invites: \(error)")
            completion(false)
        }
    }
    
    func fetchBudgetInvitations(completion: @escaping ([Invitation]) -> Void){
        let uid = self.getCurrentUid()
        
        self.db.collection(DBCollectionLabels.invites).document(uid).getDocument(completion: { snapshot, error in
            if error != nil {
                print(error!.localizedDescription)
                completion([])
            }
            else{
                do{
                    let data = try snapshot?.data(as: [String : [Invitation]].self)
                    let invites = data![FirebaseUtils.invitesFieldKey] ?? []
                    /*
                     for invite in invites{
                     print("inviation username : \(invite.getSenderUsername())")
                     print("inviation budgetId : \(invite.getBudgetReferenceID())")
                     }*/
                    completion(invites)
                }
                catch{
                    print("error: \(error)")
                    completion([])
                }
            }
            
        })
    }
    
    func sendBudgetInvitation(toUid : String, fromUsername : String, budgetRefId : String , budgetName: String, completion: @escaping (Bool) -> Void){
        
        let invite = Invitation(senderUsername: fromUsername, budgetReferenceId: budgetRefId, budgetName: budgetName)
        //let sendData = ["invites" : [invite]]
        //let value = [fromUsername, budgetRefId]
        
        let encodedInvite : [String: Any]
        
        do {
            // encode the swift struct instance into a dictionary
            // using the Firestore encoder
            encodedInvite = try Firestore.Encoder().encode(invite)
            print("encoded successfully")
            self.db.collection(DBCollectionLabels.invites).document(toUid).updateData(
                [FirebaseUtils.invitesFieldKey: FieldValue.arrayUnion([encodedInvite])]) { error in
                    guard let error = error else {
                        print("updating the invite data was successful")
                        completion(true)
                        return
                    }
                    print("ERROR updating, will try set DATA: \(error)")
                    
                    if let errCode = FirestoreErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .notFound:
                            let sendData = [FirebaseUtils.invitesFieldKey : [invite]]
                            do{
                                print("success in setting the data")
                                try self.db.collection(DBCollectionLabels.invites).document(toUid).setData(from: sendData)
                                completion(true)
                            }
                            catch{
                                print("error setting the data as well.")
                                completion(false)
                            }
                            
                        default:
                            print("some error occurred trying to update")
                            completion(false)
                        }
                    }
                    return
                    
                }
        } catch {
            // encoding error
            print("ERROR encoding: \(error)")
            completion(false)
        }
    }
    
    @MainActor func fetchUserSharedData(_ userId : String, completion: @escaping (User.SharedData?) -> Void) async throws{
        let snapshot = try await self.db.collection(DBCollectionLabels.sharedData).document(userId).getDocument()
        if snapshot.exists{
            let data = try snapshot.data(as: User.SharedData.self)
            completion(data)
        }
        else{
            completion(nil)
        }
    }
    
    @MainActor func fetchUserPrivateData(_ userId : String, completion: @escaping (User.PrivateData?) -> Void) async throws{
        let snapshot = try await self.db.collection(DBCollectionLabels.users).document(userId).getDocument()
        if snapshot.exists{
            let data = try snapshot.data(as: User.PrivateData.self)
            completion(data)
        }
        else{
            completion(nil)
        }
    }
    
    func deletePublicUsername( _ username : String, completion: @escaping (Bool) -> Void){
        self.db.collection(DBCollectionLabels.publicUsernames).document(username).delete() { err in
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
        self.db.collection(DBCollectionLabels.publicEmails).document(email).delete() { err in
            if let err = err {
                print("Error removing email: \(err)")
                completion(false)
            } else {
                print("Email successfully removed!")
                completion(true)
            }
        }
    }
    
    func archiveBudget(_ budget : Budget, _ budgetReferenceId : String, _ archiveDateString : String, completion: @escaping (Bool) -> Void){
        /*
        do{
            let sendData = [archiveDateString : budget]
            //try self.db.collection(DBCollectionLabels.archivedBudgets).document(budgetReferenceId).setData(from: sendData)
            try self.db.collection(DBCollectionLabels.archivedBudgets).document(budgetReferenceId).updateData(sendData)
            print("success in setting the archived budget data")
            completion(true)
        }
        catch{
            print("error setting the archived budget data.")
            completion(false)
        }
        */
        
        let encodedBudget : [String: Any]
        
        do {
            // encode the swift struct instance into a dictionary
            // using the Firestore encoder
            encodedBudget = try Firestore.Encoder().encode(budget)
            print("encoded successfully")
            self.db.collection(DBCollectionLabels.archivedBudgets).document(budgetReferenceId).updateData(
                [archiveDateString: encodedBudget]) { error in
                    guard let error = error else {
                        print("updating the archived budget data was successful")
                        completion(true)
                        return
                    }
                    print("ERROR updating archived budget, will try set DATA: \(error)")
                    
                    if let errCode = FirestoreErrorCode(rawValue: error._code) {
                        switch errCode {
                        case .notFound:
                            let sendData = [archiveDateString : budget]
                            do{
                                print("success in setting the data")
                                try self.db.collection(DBCollectionLabels.archivedBudgets).document(budgetReferenceId).setData(from: sendData)
                                completion(true)
                            }
                            catch{
                                print("error setting the data as well.")
                                completion(false)
                            }
                            
                        default:
                            print("some error occurred trying to update")
                            completion(false)
                        }
                    }
                    return
                    
                }
        } catch {
            // encoding error
            print("ERROR encoding: \(error)")
            completion(false)
        }
    }
    
    func fetchBudget(_ budgetId : String, completion: @escaping (Budget?) -> Void){
        let docRef = self.db.collection(DBCollectionLabels.budgets).document(budgetId)
        
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
    
    @MainActor func fetchBudgetNonAsync(_ budgetId : String, completion: @escaping (Budget?) -> Void) async throws{
        let snapshot = try await self.db.collection(DBCollectionLabels.budgets).document(budgetId).getDocument()
        
        if snapshot.exists{
            let data = try snapshot.data(as: Budget.self)
            print("fetching budget")
            completion(data)
        }
        else{
            completion(nil)
        }
    }
    
    func updateBudget(_ budget : Budget, _ referenceId : String, completion: @escaping (Bool) -> Void){
        do{
            try self.db.collection(DBCollectionLabels.budgets).document(referenceId).setData(from: budget)
            print("UPDATED Budget with new users list: \(budget.linkedUserIds)")
            completion(true)
        }
        catch{
            print("error in updating budget: \(error)")
            completion(false)
        }
    }
    
    func deleteBudget(_ referenceId : String, completion: @escaping (Bool) -> Void){
        self.db.collection(DBCollectionLabels.budgets).document(referenceId).delete() { err in
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
        self.db.collection(DBCollectionLabels.users).document(userId).delete() { err in
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
        self.db.collection(DBCollectionLabels.sharedData).document(userId).delete() { err in
            if let err = err {
                print("Error removing shared data: \(err)")
                completion(false)
            } else {
                print("Shared Data successfully removed!")
                completion(true)
            }
        }
    }
    
    
    func deleteInvitationsData(_ userId : String, completion: @escaping (Bool) -> Void){
        self.db.collection(DBCollectionLabels.invites).document(userId).delete() { err in
            if let err = err {
                print("Error removing invitations data: \(err)")
                completion(false)
            } else {
                print("Invitations Data successfully removed!")
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
