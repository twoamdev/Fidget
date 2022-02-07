//
//  BucketsViewModel.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/5/22.
//

import SwiftUI
import Firebase

class BucketsViewModel : ObservableObject {
    
    @Published var userHasBudget : Bool = false
    @Published var budgetCreated : Bool = false
    
    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    private var budgets : [Budget] = []
    
    init(){
        fetchBudgets()
    }
    
    func fetchBudgets(){
        if let uid = self.auth.currentUser?.uid{
            let document = self.db
                .collection(DatabaseCollections().users)
                .document(uid)
                .collection(DatabaseCollections().userData)
                .document(DatabaseDocs().budgetReferences)
            
            
            document.getDocument { (snapshot, err) in
                guard let snapshot = snapshot else {
                    print("Error \(err!)")
                    self.userHasBudget = false
                    return
                }
                if snapshot.exists {
                    let incomingData : [String : Any] = snapshot.data()!
                    let budgetIds = incomingData[DatabaseDocs().budgetIds] as! [String]
                    for myid in budgetIds{
                        print("ID: \(myid)")
                        self.fetchBudgetByReferenceId(myid)
                    }
                    self.userHasBudget = true
                }
                else{
                    print("doesn't exist")
                    self.userHasBudget = false
                }
            }
        }
    }
    
    
    private func fetchBudgetByReferenceId(_ budgetId : String) {
        print("got to fetchBudgetByRef ID")
        let document = self.db
            .collection(DatabaseCollections().budgets)
            .document(budgetId)
        
        document.getDocument { (snapshot, err) in
            guard let snapshot = snapshot else {
                print("Error fetching budget by reference ID\(err!)")
                return
            }
            
            print("before snapshot")
            //Do something
            if snapshot.exists{
                print("snapshot exists")
                let data : [String : Any] = snapshot.data() ?? [:]
                let budgetName = data[DatabaseFields().budgetName] as? String ?? ""
                let budgetIncomes = data[DatabaseFields().budgetIncomes] as? NSArray ?? []
                let budgetBuckets = data[DatabaseFields().budgetBuckets] as? NSArray ?? []
                
                //Create budget
                let budget = Budget(budgetName, firestoreBuckets: budgetBuckets, firestoreIncomes: budgetIncomes)
                
                print("MY BUDGET: \(budget)")
                //self.budgets.append(budget)
            }
            else{
                print("snapshot DOESNT exists")
            }
        }
    }
    
    
    
    
    
    func createBudget(_ budget : Budget) {
        self.bundleBudget(budget)
    }
    
    private func bundleBudget(_ budget : Budget){
        if self.auth.currentUser?.uid != nil{
            let budgetData : [String : Any] = [DatabaseFields().budgetName    : budget.getBudgetName(),
                                               DatabaseFields().budgetIncomes : budget.getIncomesEncodedForFirestore(),
                                               DatabaseFields().budgetBuckets : budget.getBucketsEncodedForFirestore()]
            
            let document = self.db.collection(DatabaseCollections().budgets).addDocument(data: budgetData)
            document.getDocument { (snapshot, err) in
                guard let snapshot = snapshot else {
                    print("Error getting a new Budget created \(err!)")
                    return
                }
                self.budgetCreated = true
                let budgetId = snapshot.documentID
                self.linkUserToBudget(budgetId)
            }
        }
    }
    
    private func linkUserToBudget(_ budgetId : String){
        if let uid = self.auth.currentUser?.uid{
            let document = self.db
                .collection(DatabaseCollections().users)
                .document(uid)
                .collection(DatabaseCollections().userData)
                .document(DatabaseDocs().budgetReferences)
            
            
            document.getDocument { (snapshot, err) in
                guard let snapshot = snapshot else {
                    print("Error getting budget ID references: \(err!)")
                    return
                }
                
                //If data exists, append to it
                var mydata : [String : Any] = [:]
                if snapshot.exists {
                    let incomingData : [String : Any] = snapshot.data()!
                    let budgetIds = incomingData[DatabaseDocs().budgetIds] as! [String]
                    var newArray : [String] = []
                    for myId in budgetIds{
                        newArray.append(myId)
                    }
                    newArray.append(budgetId)
                    mydata[DatabaseDocs().budgetIds] = newArray
                    
                }
                //If no data exists, create it
                else{
                    mydata = [DatabaseDocs().budgetIds : [budgetId]]
                }
                //Set the final budgetIds reference data in the user/budgetReferences document
                self.db.collection(DatabaseCollections().users)
                    .document(uid).collection(DatabaseCollections().userData)
                    .document(DatabaseDocs().budgetReferences).setData(mydata) { [weak self] err in
                    guard self != nil else { return }
                        if let err = err {
                            print("Error writing budget ID refs: \(err)")
                        }
                }
            }
        }
    }
    
}
