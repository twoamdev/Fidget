//
//  Budget.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/5/22.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

struct Budget : Codable {
    var id = UUID().uuidString
    var name : String
    var buckets : [Bucket]
    var incomes : [IncomeItem]
    var transactions : Dictionary<String,[Transaction]>
    //var test : String
        
    init(_ budgetName: String, _ buckets : [Bucket], _ incomeItems : [IncomeItem], _ transactions : [Transaction]){
        self.name = budgetName
        self.buckets = buckets
        self.incomes = incomeItems
        self.transactions = [:]
        //self.test = ""
        self.mapTransactions(transactions)
        
    }
    
    init(){
        self.name = ""
        self.buckets = []
        self.incomes = []
        self.transactions = [:]
        //self.test = ""
    }
    
    /* maps given transactions with the buckedId as the key for fast look up later*/
    mutating func mapTransactions( _ transactions : [Transaction]){
        for transaction in transactions {
            let key = transaction.bucketId
            if key != "" {
                if self.transactions.keys.contains(key){
                    self.transactions[key]?.append(transaction)
                }
                else{
                    self.transactions[key] = [transaction]
                }
            }
        }
    }
    
    mutating func emptyTransactions(){
        self.transactions = [:]
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

extension Budget {
    enum CodingKeys: String, CodingKey {
            case id, name, buckets, incomes, transactions
        }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(buckets, forKey: .buckets)
        try container.encode(incomes, forKey: .incomes)
        try container.encode(transactions, forKey: .transactions)
        //try container.encode(test, forKey: .test)
    }
    
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        name = (try? container.decode(String.self, forKey: .name)) ?? ""
        buckets = (try? container.decode([Bucket].self, forKey: .buckets)) ?? []
        incomes = (try? container.decode([IncomeItem].self, forKey: .incomes)) ?? []
        transactions = (try? container.decode([String:[Transaction]].self, forKey: .transactions)) ?? [:]
        //test = (try? container.decode(String.self, forKey: .test)) ?? "DUMMY"
    }
}
