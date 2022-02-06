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
    
    init(){
        fetchBudgets()
    }
    
    func fetchBudgets(){
        
        let db = Firestore.firestore()
        let auth = Auth.auth()
        
        
        if let uid = auth.currentUser?.uid{
            let document = db
                .collection(DatabaseCollections().users)
                .document(uid)
                .collection(DatabaseCollections().userData)
                .document(DatabaseDocs().budgets)
            
            
            document.getDocument { (snapshot, err) in
                guard let snapshot = snapshot else {
                    print("Error \(err!)")
                    self.userHasBudget = false
                    return
                }
                if snapshot.exists {
                    self.userHasBudget = true
                }
                else{
                    self.userHasBudget = false
                }
            }
        }
    }
}
