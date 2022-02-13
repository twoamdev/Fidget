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
        var editedBudget : Budget = self.budget
        editedBudget.buckets.append(bucket)
        updateBudget(editedBudget)
    }
    
    func removeBucketFromBudget(_ bucket : Bucket){
        var editedBudget : Budget = self.budget
        var bucketIndex = -1
        for (index, element) in editedBudget.buckets.enumerated() {
            if element.id == bucket.id{
                bucketIndex = index
            }
        }
        
        if bucketIndex != -1{
            editedBudget.buckets.remove(at: bucketIndex)
        }
        
        updateBudget(editedBudget)
    }
    
    private func updateBudget(_ budget : Budget){
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
    
    func saveBudget(_ budget : Budget) {
        do{
            let doc = try self.db.collection("budgets").addDocument(from: budget)
            if let uid = auth.currentUser?.uid{
                
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
