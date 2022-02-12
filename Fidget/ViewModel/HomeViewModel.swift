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
    @Published var budgets : [Budget] = []
    @Published var currentBudgetIndex : Int = 0
    @Published var budgetIds : [String] = []
    @Published var loading : Bool = false
    
    
    
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    //["9ET13gIMC5NUcmwpEubx","Lk9Pg0Dw89yasQfbsoUm"]
    
    func currentBudgetName() -> String{
        let budgetName = self.budgets.count > 0 ? self.budgets[self.currentBudgetIndex].name : "NO BUDGET"
        return budgetName
    }
    
    func currentBudgetBuckets() -> [Bucket] {
        let buckets = self.budgets.count > 0 ? self.budgets[self.currentBudgetIndex].buckets : []
        return buckets
    }
    
    func setCurrentBudgetIndex(_ menuItemIndex : Int) {
        self.currentBudgetIndex = menuItemIndex
    }
    
    func saveBudget(_ budget : Budget) {
        do{
            let doc = try self.db.collection("budgets").addDocument(from: budget)
            if let uid = auth.currentUser?.uid{
                self.db.collection("users").document(uid).collection("userData")
                    .document("budgetReferences").updateData(["ids" : FieldValue.arrayUnion([doc.documentID])]){ (error) in
                        if error != nil{
                            if FirestoreErrorCode(rawValue: error?._code ?? 0) == FirestoreErrorCode.notFound{
                                self.db.collection("users").document(uid).collection("userData")
                                        .document("budgetReferences").setData(["ids" : [doc.documentID]])
                            }
                            else{
                                print(error?.localizedDescription ?? "")
                            }
                        }
                    }
            }
        }
        catch{
            print(error)
        }
    }
    
    
    
    
    func fetchBudgets(){
      
        Task{
            do{
                self.loading = true
                try await self.loadBudgetReferenceIds(completion: { (incomingIds) in
                    self.budgetIds = incomingIds
                })
                for myid in self.budgetIds{
                    try await self.grabBudgetById(myid, completion: { (incomingBudget) in
                        self.updateBudgets(incomingBudget)
                        self.userHasBudget = true
                    })
                }
                self.loading = false
            }
            catch{
                print(error)
            }
        }

        if self.budgets.isEmpty{
            self.userHasBudget = false
        }
            
    }
    
    /*
     Unions properly -- if a budget in the list exists, it is updated. If it doesn't exist, it is added
     */
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
    }
    
    private func loadBudgetReferenceIds(completion: @escaping ([String]) -> Void) async throws{
        //print("LOAD BUDGET REF IDS CALLED")
        if let uid = self.auth.currentUser?.uid{
            
            let snapshot = try await self.db.collection("users").document(uid).collection("userData")
                .document("budgetReferences").getDocument()
            
            if let myids : [String : Any] = snapshot.data(){
                let ids = myids["ids"] as? [String] ?? []
                //print("IDS in function: \(ids)")
                completion(ids)
            }
        }
        //completion([])
    }
    
    private func grabBudgetById(_ budgetId : String, completion: @escaping (Budget) -> Void) async throws {
        self.db.collection("budgets").document(budgetId).addSnapshotListener{ (snapshot, error) in
            if let buddy = try? snapshot?.data(as: Budget.self){
                completion(buddy)
            }
        }
    }
    
    
    
}
