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
    
    private var budgetLinker : Budget.Link = Budget.Link()
    private var bucketNames : [String : String] = [:]

    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    private var budgetListener : ListenerRegistration?
    
    init(){
        self.fetchBudget()
    }
    
    
    func getUserBudgetIdReferences() -> [String] {
        return self.budgetLinker.referenceIds
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
        Task{
            do{
                
                let refId = self.budgetLinker.getSelectedRefId()
                try await self.db.collection("budgets").document(refId).setData(from: budget)
                self.budget = budget
                
                
            }
            catch{
                print(error)
            }
        }
    }
    
    func saveNewBudget(_ budgetName : String, _ buckets : [Bucket], _ incomeItems : [Budget.IncomeItem], _ transactions : [Transaction]) {
        do{
            if let uid = auth.currentUser?.uid{
                let budget = Budget(budgetName, buckets, incomeItems, transactions)
                let doc = try self.db.collection("budgets").addDocument(from: budget)
            
                
                self.db.collection("users").document(uid).collection("userData")
                    .document("budgetReferences").updateData(["referenceIds" : FieldValue.arrayUnion([doc.documentID])]){ (error) in
                        if error != nil{
                            if FirestoreErrorCode(rawValue: error?._code ?? 0) == FirestoreErrorCode.notFound{
                                self.db.collection("users").document(uid).collection("userData")
                                        .document("budgetReferences").setData(["referenceIds" : [doc.documentID],
                                                                               "selectedIdIndex" : 0])
                                self.fetchBudget()
                            }
                            else{
                                print(error?.localizedDescription ?? "")
                            }
                        }
                         
                    }
                self.fetchBudget() 
            }
        }
        catch{
            print(error)
        }
    }
        
    func fetchBudget(){
      
        Task{
            do{
                self.loading = true
                try await self.fetchUserBudgetReferenceIds(completion: { (incomingLinker) in
                    self.budgetLinker = incomingLinker
                })
                
                if !self.budgetLinker.referenceIds.isEmpty{
                    try await self.addBudgetListenerFromReferenceId(self.budgetLinker.getSelectedRefId(),
                                                                    completion: { (incomingBudget) in
                        self.budget = incomingBudget
                        self.loadBucketNames()
                        self.userHasBudget = true
                    })
                }
                
                
                
                self.loading = false
            }
            catch{
                print(error)
            }
        }  
    }
    
    private func loadBucketNames(){
        for myBucket in self.budget.buckets{
            let id = myBucket.id
            let name = myBucket.name
            self.bucketNames[name] = id
        }
    }
    
    private func fetchUserBudgetReferenceIds(completion: @escaping (Budget.Link) -> Void) async throws{
        //print("LOAD BUDGET REF IDS CALLED")
        if let uid = self.auth.currentUser?.uid{
            
            let snapshot = try await self.db.collection("users").document(uid).collection("userData")
                .document("budgetReferences").getDocument()
            
            let linker = try snapshot.data(as: Budget.Link.self)
            completion(linker ?? Budget.Link())
        }
    }
    
    private func addBudgetListenerFromReferenceId(_ referenceId : String, completion: @escaping (Budget) -> Void) async throws {
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
