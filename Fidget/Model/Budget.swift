//
//  Budget.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/5/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Budget : Codable {
    var id = UUID().uuidString
    var name : String
    var buckets : [Bucket]
    var incomes : [IncomeItem]
    var transactions : Dictionary<String,[Transaction]>
    
    init(_ budgetName: String, _ buckets : [Bucket], _ incomeItems : [IncomeItem], _ transactions : [Transaction]){
        self.name = budgetName
        self.buckets = buckets
        self.incomes = incomeItems
        self.transactions = [:]
        self.mapTransactions(transactions)
    }
    
    init(){
        self.name = ""
        self.buckets = []
        self.incomes = []
        self.transactions = [:]
    }
    
    /* maps given transactions with the buckedId as the key for fast look up later*/
    mutating func mapTransactions( _ transactions : [Transaction]){
        for transaction in transactions {
            let key = transaction.bucketId
            if key != "" {
                if self.transactions.keys.contains(key){
                    var bucketTransactions = self.transactions[key] ?? []
                    bucketTransactions.append(transaction)
                    self.transactions[key] = transactions
                }
                else{
                    self.transactions[key] = [transaction]
                }
            }
        }
    }
   
    
    struct IncomeItem : Codable {
        var name : String
        var amount : Double
        
        init(){
            self.name = ""
            self.amount = 0.0
           
        }
        init(_ name : String, _ amount : Double){
            self.name = name
            self.amount = amount
           
        }
    }
    
    struct Link : Codable {
        var referenceIds : [String]
        var selectedIdIndex : Int
        
        init(_ ids : [String], _ index : Int){
            self.referenceIds = ids
            self.selectedIdIndex = index
        }
        
        init(){
            self.referenceIds = []
            self.selectedIdIndex = 0
        }
        
        func getSelectedRefId() -> String{
            if self.referenceIds.isEmpty || self.selectedIdIndex >= self.referenceIds.count {
                return ""
            }
            else{
                return self.referenceIds[self.selectedIdIndex]
            }
        }
    }
    
}
