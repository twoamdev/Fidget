//
//  BucketsViewModel.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/5/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class HomeViewModel : ObservableObject {
    
    @Published var userHasBudget : Bool = false
    @Published var budgets : [Budget] = []
    @Published var currentBudgetIndex : Int = 0
    
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    
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
            self.userHasBudget = true
            self.budgets.append(budget)
            if let uid = auth.currentUser?.uid{
                self.db.collection("users").document(uid).collection("userData")
                    .document("budgetReferences").updateData(["ids" : FieldValue.arrayUnion([doc.documentID])]){ (error) in
                        if error != nil{
                        
                            let code = FirestoreErrorCode(rawValue: error?._code ?? 0)
                            
                            if code == FirestoreErrorCode.notFound{
                                self.db.collection("users").document(uid).collection("userData")
                                        .document("budgetReferences").setData(["ids" : [doc.documentID]])
                            }
                        }
                        
                    }
            }
        }
        catch{
            print(error)
        }
    }
    
    func fetchBudgets() {
        db.collection("budgets").addSnapshotListener{ (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("no documents found")
                return
            }
            
            self.budgets = documents.compactMap{ (queryDocumentSnapshot) -> Budget? in
                return try? queryDocumentSnapshot.data(as: Budget.self)
            }
        }
    }
    
    
    
}
