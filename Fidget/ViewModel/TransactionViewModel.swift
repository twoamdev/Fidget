//
//  TransactionViewModel.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/19/22.
//

import SwiftUI
import Firebase

class TransactionViewModel : ObservableObject {
    @Published var userIdToSharedDataMap : [String : User.SharedData]
    private var userIdToSharedDataListener : [String : ListenerRegistration]
    private let db = Firestore.firestore()
    
    init(){
        self.userIdToSharedDataMap = [:]
        self.userIdToSharedDataListener = [:]
    }
    
    func purgeData(){
        self.clearSharedData()
        self.removeSharedDataListeners()
        print("cleared listeners")
    }
    
    func transactionOwnerDisplayName(_ transaction : Transaction) -> String {
        let userId = transaction.ownerId
        let myUserId = FirebaseUtils().getCurrentUid()
        let transactionIsFromCurrentUser = userId == myUserId ? true : false
        
        if self.userIdToSharedDataMap.keys.contains(userId){
            let data : User.SharedData = self.userIdToSharedDataMap[userId] ?? User.SharedData(String(), String(), String())
            return self.displayNameFromSharedData(data, transactionIsFromCurrentUser)
        }
        else{
            self.addSharedDataListener(userId, completion:{ (userData) in
                self.userIdToSharedDataMap[userId] = userData
            })
            let data = self.userIdToSharedDataMap[userId] ?? User.SharedData(String(), String(), String())
            return self.displayNameFromSharedData(data, transactionIsFromCurrentUser)
        }
    }
    
    func addSharedDataListener(_ userId : String, completion: @escaping (User.SharedData) -> Void){
        self.userIdToSharedDataListener[userId]?.remove()
        self.userIdToSharedDataListener[userId] = self.db.collection("sharedData").document(userId).addSnapshotListener{ (snapshot, error) in
            if let data = try? snapshot?.data(as: User.SharedData.self){
                completion(data)
            }
            else{
                print(error as Any)
            }
        }
    }
    
    func removeSharedDataListeners(){
        for dataListener in self.userIdToSharedDataListener.values {
            dataListener.remove()
        }
    }
    
    func clearSharedData(){
        self.userIdToSharedDataMap = [:]
    }
    
    private func displayNameFromSharedData(_ data : User.SharedData, _ transactionIsFromCurrentUser : Bool) -> String {
        if data.username.isEmpty{
            if transactionIsFromCurrentUser {
                return FirebaseUtils.isCurrentUser
            }
            else{
                return FirebaseUtils.noUserFound
            }
        }
        else{
            return "@"+data.username
        }
    }
    
}

