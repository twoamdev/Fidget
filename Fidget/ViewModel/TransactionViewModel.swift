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
    
    func transactionOwnerDisplayName(_ transaction : Transaction) -> String {
        let userId = transaction.ownerId
        if self.userIdToSharedDataMap.keys.contains(userId){
            let data : User.SharedData = self.userIdToSharedDataMap[userId] ?? User.SharedData(String(), String(), String())
            return self.displayNameFromSharedData(data)
        }
        else{
            self.addSharedDataListener(userId, completion:{ (userData) in
                self.userIdToSharedDataMap[userId] = userData
            })
            let data = self.userIdToSharedDataMap[userId] ?? User.SharedData(String(), String(), String())
            return self.displayNameFromSharedData(data)
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
    
    private func displayNameFromSharedData(_ data : User.SharedData) -> String {
        if data.username.isEmpty{
            return FirebaseUtils.noUserFound
        }
        else{
            return "@"+data.username
        }
    }
    
}

