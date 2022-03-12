//
//  BucketsViewModel.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/5/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

@MainActor class HomeViewModel : ObservableObject {
    
    @Published var userHasBudget : Bool = false
    @Published var budget : Budget = Budget()
    @Published var loading : Bool = true
    @Published var bucketSearchResults : [String] = []
    
    //@Published private var _userIsSignedIn : Bool = false
    
    
    private var bucketNames : [String : String] = [:]
    private var userPrivateData : User.PrivateData = User.PrivateData(String())

    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    private var budgetListener : ListenerRegistration?

    func getUserBudgetIdReferences() -> [String] {
        return self.userPrivateData.budgetLinker.referenceIds
    }
    
    func transactionOwnerName(_ ownerId : String) -> String{
        return ""
    }
    
    func bucketNameSearch(_ input : String){
        let keys = self.bucketNames.keys
        var results : [String] = []
        for myKey in keys {
            let name = myKey.lowercased()
            let myInput = input.lowercased()
            if name.contains(myInput) {
                if results.count < 3{
                    results.append(myKey)
                }
            }
        }
        self.bucketSearchResults = results
    }
    
    func bucketBalance(_ bucketId : String) -> Double {
        var balance = 0.0
        let transactions = self.budget.transactions[bucketId] ?? []
        for trans in transactions{
            balance += trans.amount
        }
        return balance
    }

    func addBucketToBudget(_ bucket : Bucket){
        self.budget.buckets.append(bucket)
        updateExistingBudget(self.budget)
    }
    
    func addBucketWithTransactionToBudget(_ bucket : Bucket, _ transaction : Transaction){
        self.budget.buckets.append(bucket)
        self.budget.mapTransactions([transaction])
        updateExistingBudget(self.budget)
    }
    
    func loadRecentTransactions() -> [Transaction]{
        
        var myTransactions : [Transaction] = []
        for pair in self.budget.transactions{
            let transactions = pair.value
            myTransactions += transactions
        }
        
        let budgetDataUtils = BudgetDataUtils()
        myTransactions = budgetDataUtils.sortTransactionsFromNewestToOldest(myTransactions)
        return myTransactions
    }
    
    func transactionsInBucket(_ bucketId : String) -> [Transaction]{
        return self.budget.transactions[bucketId] ?? []
    }
    
    func transanctionBucketName(_ transaction : Transaction) -> String{
        for bucket in self.budget.buckets{
            if bucket.id == transaction.bucketId{
                return bucket.name
            }
        }
        return "--name not found"
    }
    
    func addTransaction(_ bucketName : String, _ amount : Double){
        if amount != .zero{
            if let uid = self.auth.currentUser?.uid{
                let bucketId = bucketNames[bucketName]
                let transaction = Transaction(uid, bucketId ?? "", "", amount, "")
                self.budget.mapTransactions([transaction])
                updateExistingBudget(self.budget)
            }
        }
    }
    
    
    func removeBucketFromBudget(_ offsets : IndexSet){
        if offsets.count == 1 {
            let index : Int = offsets[offsets.startIndex]
            var editedBudget : Budget = self.budget
            let bucketId = editedBudget.buckets[index].id
            editedBudget.buckets.remove(atOffsets: offsets)
            editedBudget.transactions.removeValue(forKey: bucketId)
            updateExistingBudget(editedBudget)
        }
    }
    
    func removeTransactionFromBudget(_ offsets : IndexSet, _ bucketId : String){
        if offsets.count == 1 {
            let reversedIndex : Int = offsets[offsets.startIndex]
            let count = self.budget.transactions[bucketId]?.count ?? .zero
            if count != .zero{
                let index = (count-1) - reversedIndex
                self.budget.transactions[bucketId]?.remove(at: index)
                updateExistingBudget(self.budget)
            }
            
        }
    }
    
    func renewBudget(){
        
        let oldBudget = self.budget
        var renewBudget = self.budget
        let budgetDataUtils = BudgetDataUtils()
        
        let bucketCount = renewBudget.buckets.count
        for i in 0..<bucketCount {
            if renewBudget.buckets[i].rolloverEnabled{
                let key = renewBudget.buckets[i].id
                let transactions = renewBudget.transactions[key] ?? []
                let rolloverAmt = renewBudget.buckets[i].capacity - budgetDataUtils.calculateBalance(transactions, key)
                renewBudget.buckets[i].rolloverCapacity += rolloverAmt
            }
            else{
                renewBudget.buckets[i].rolloverCapacity = 0.0
            }
        }
        
        //Now that rollover is calculated, empty transactions
        renewBudget.emptyTransactions()
        updateExistingBudget(renewBudget)
    }
    
    
    private func updateExistingBudget(_ budget : Budget){
            do{
                
                let refId = self.userPrivateData.budgetLinker.getSelectedRefId()
                try self.db.collection("budgets").document(refId).setData(from: budget)
                self.budget = budget
                
                
            }
            catch{
                print(error)
            }
    }
    
    func saveNewBudget(_ budgetName : String, _ buckets : [Bucket], _ incomeItems : [Budget.IncomeItem], _ transactions : [Transaction]) {
        do{
            if let uid = auth.currentUser?.uid{
                let budget = Budget(budgetName, buckets, incomeItems, transactions)
                let doc = try self.db.collection("budgets").addDocument(from: budget)
             
                var updatedUserPrivateData = self.userPrivateData
                updatedUserPrivateData.budgetLinker.referenceIds.append(doc.documentID)
                updatedUserPrivateData.budgetLinker.selectedIdIndex = updatedUserPrivateData.budgetLinker.referenceIds.count - 1
                try self.db.collection("users").document(uid).setData(from: updatedUserPrivateData)
                
                self.syncBudgetAndUserData()
            }
        }
        catch{
            print(error)
        }
    }
        
    func syncBudgetAndUserData(comingFromSignUp : Bool = false){
        if comingFromSignUp {
            print("sync from SIGN UP request")
            
            
        }
        else{
            print("sync from OTHER requests")
            
            
            
        }
        /*
        Task{
            do{
                self.loading = true
                try await self.fetchUserPrivateData()
                
                if !self.userPrivateData.budgetLinker.referenceIds.isEmpty{
                    try await self.addBudgetListener(self.userPrivateData.budgetLinker.getSelectedRefId(), completion: { (loadedBudget) in
                        self.budget = loadedBudget
                        self.bucketNames = BudgetDataUtils().loadBucketNames(self.budget.buckets)
                        self.userHasBudget = true
                    })
                }
                self.loading = false
            }
            catch{
                print(error)
            }
        }
         */
    }
    
    private func fetchUserPrivateData() async throws{
        if let uid = self.auth.currentUser?.uid{
            try await ProfileUtils().fetchUserPrivateInfo(uid){ (data) in
                if data != nil{
                    let privateData : User.PrivateData = data!
                    self.userPrivateData = privateData
                }
            }
        }
    }
    
    private func addBudgetListener(_ referenceId : String, completion: @escaping (Budget) -> Void) async throws {
        self.removeBudgetListener()
        self.budgetListener = self.db.collection("budgets").document(referenceId).addSnapshotListener{ (snapshot, error) in
            if let mybudget = try? snapshot?.data(as: Budget.self){
                completion(mybudget)
            }
        }
    }
    
    func removeBudgetListener(){
        self.budgetListener?.remove()
    }
    
    
}
