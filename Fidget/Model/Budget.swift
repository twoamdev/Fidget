//
//  Budget.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/5/22.
//

import Foundation


struct Budget {
    
    private var name : String
    private var buckets : [Bucket]
    private var incomes : [IncomeItem]
    
    init(budgetName: String, _ buckets : [Bucket], _ incomeItems : [IncomeItem]){
        self.name = budgetName
        self.buckets = buckets
        self.incomes = incomeItems
    }
    
    
    init(_ budgetName : String, firestoreBuckets : NSArray, firestoreIncomes : NSArray){
        self.name = budgetName
        
        //Buckets
        var buckets : [Bucket] = []
        for firestoreBucket in firestoreBuckets {
             buckets.append(Bucket(firestoreBucket: firestoreBucket))
        }
        self.buckets = buckets
        
        //income items
        var incomes : [IncomeItem] = []
        for firestoreIncome in firestoreIncomes{
            incomes.append(IncomeItem(firestoreItem: firestoreIncome))
        }
        self.incomes = incomes
    }
     
    
    
    func getBudgetName() -> String {
        return self.name
    }
    
    func getBuckets() -> [Bucket] {
        return self.buckets
    }
    
    func getBucketsEncodedForFirestore() ->  [[String:Any]] {
        var encodedBuckets : [[String:Any]] = []
        
        for bucket in self.buckets {
            let encoded = bucket.encodeBucket()
            encodedBuckets.append(encoded)
        }
        
        return encodedBuckets
    }
    
    func getIncomes() -> [IncomeItem]{
        return self.incomes
    }
    
    func getIncomesEncodedForFirestore() -> [[String : Any]] {
        var encodedIncomeItems : [[String : Any]] = []
        
        for incomeItem in self.incomes {
            let encodedItem = incomeItem.encodeIncomeItem()
            encodedIncomeItems.append(encodedItem)
        }
        
        
        return encodedIncomeItems
    }
    
    struct IncomeItem : Identifiable, Hashable{
        var id  = UUID()
        var name : String
        var amount : String
        
        init(){
            self.name = ""
            self.amount = ""
           
        }
        init(_ name : String, _ amount : String){
            self.name = name
            self.amount = amount
           
        }
        
        init(firestoreItem : Any){
            //let data : [String : Any] = firestoreBucket as? [String : Any] ?? [:]
            let item : [String : Any] = firestoreItem as? [String : Any] ?? [:]
            self.name = item["name"] as? String ?? ""
            self.amount = item["amount"] as? String ?? ""
        }
        
        func encodeIncomeItem() -> [String : Any]{
            let encoding : [String : Any] = [ "name" : self.name,
                                              "amount" : self.amount]
            return encoding
        }
    }
}
