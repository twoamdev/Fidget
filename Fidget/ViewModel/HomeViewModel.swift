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
    private var budgetLinker : Budget.Link = Budget.Link()

    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    
    
    func userBudgetNames() -> [String] {
        return self.budgetLinker.referenceIds
    }
    
    func addBucketToBudget(_ bucket : Bucket){
        if let uid =  auth.currentUser?.uid {
            var editedBudget : Budget = self.budget
            let result : (Bucket, Transaction, Bool) = convertBucketValueToTransaction(bucket, uid)
            editedBudget.buckets.append(result.0)
            editedBudget = processBucketValueToTransactionResult(result, editedBudget)
            updateExistingBudget(editedBudget)
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
    
    func saveNewBudget(_ budget : Budget) {
        
        do{
            if let uid = auth.currentUser?.uid{
                let convertedBudget = convertInitalBucketBalancesToTransactions(budget, uid)
                let doc = try self.db.collection("budgets").addDocument(from: convertedBudget)
            
                
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
        
    private func convertInitalBucketBalancesToTransactions(_ budget : Budget, _ uid : String) -> Budget{
        var convertBudget = budget
        for i in convertBudget.buckets.indices {
            let result : (Bucket, Transaction, Bool) = convertBucketValueToTransaction(convertBudget.buckets[i], uid)
            convertBudget.buckets[i] = result.0
            convertBudget = processBucketValueToTransactionResult(result, convertBudget)
        }
        return convertBudget
    }
    
    
    
    private func convertBucketValueToTransaction(_ bucket : Bucket, _ uid : String) -> (Bucket, Transaction, Bool) {
        var myBucket = bucket
        var transaction = Transaction()
        var useTransaction = false
        if myBucket.value != 0.0 {
            // create transaction
            
            transaction.amount = myBucket.value
            transaction.bucketId = myBucket.id
            transaction.merchantName = "None"
            transaction.setDate(Date())
            transaction.note = "Transaction auto-generated when created."
            transaction.ownerId = uid
            
            // zero out the amount
            myBucket.value = 0.0
            
            //use it
            useTransaction = true
        }
        return (myBucket, transaction, useTransaction)
    }
    
    private func processBucketValueToTransactionResult(_ result : (Bucket, Transaction, Bool), _ budget : Budget) -> Budget{
        var convertBudget = budget
        if result.2 {
            let key = result.0.id
            if convertBudget.transactions.keys.contains(key){
                var transactions = convertBudget.transactions[key] ?? []
                transactions.append(result.1)
                convertBudget.transactions[key] = transactions
            }
            else{
                convertBudget.transactions[key] = [result.1]
            }
        }
        return convertBudget
    }
    
    func fetchBudget(){
      
        Task{
            do{
                self.loading = true
                try await self.fetchUserBudgetReferenceIds(completion: { (incomingLinker) in
                    self.budgetLinker = incomingLinker
                    print("LINKER: \(self.budgetLinker)")
                })
                
                if !self.budgetLinker.referenceIds.isEmpty{
                    try await self.addBudgetListenerFromReferenceId(self.budgetLinker.getSelectedRefId(), completion: { (incomingBudget) in
                        self.budget = incomingBudget
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
    
    /*
     Unions properly -- if a budget in the list exists, it is updated. If it doesn't exist, it is added
     */
    /*
    private func updateBudgets(_ budget : Budget){
        var i = -1
        for (index, element) in self.budgets.enumerated(){
            if element.id == budget.id{
                i = index
            }
        }
        if i != -1{
            self.budgets.remove(at: i)
            self.budgets.insert(budget, at: i)
        }
        else{
            self.budgets.append(budget)
        }
    }*/
    
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
        self.db.collection("budgets").document(referenceId).addSnapshotListener{ (snapshot, error) in
            if let mybudget = try? snapshot?.data(as: Budget.self){
                completion(mybudget)
            }
        }
    }
    
    
    
}
