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
    var name : String {
        get{
            return _name
        }
        set (value){
            _name = value.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    private var _name : String
    var buckets : [Bucket]
    var incomes : [IncomeItem]
    var transactions : Dictionary<String,[Transaction]>
    var linkedUserIds : [String]
    private var lastArchiveInSeconds : Double
        
    init(_ budgetName: String, _ buckets : [Bucket], _ incomeItems : [IncomeItem], _ transactions : [Transaction], _ linkedUsers : [String]){
        self._name = String()
        self.buckets = buckets
        self.incomes = incomeItems
        self.transactions = [:] //set this to empty first
        self.linkedUserIds = linkedUsers
        self.lastArchiveInSeconds = Date().timeIntervalSince1970
        self.mapTransactions(transactions)
        self.name = budgetName
    }
    
    init(){
        self._name = String()
        self.buckets = []
        self.incomes = []
        self.transactions = [:]
        self.linkedUserIds = []
        self.lastArchiveInSeconds = Date().timeIntervalSince1970
        self.name = String()
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
    
    func nonMappedTransactions() -> [Transaction] {
        var allTransactions : [Transaction] = []
        for myPair in self.transactions{
            allTransactions += myPair.value
        }
        return allTransactions
    }
    
    func getLastArchiveInSeconds() -> Double {
        return self.lastArchiveInSeconds
    }
    
    mutating func setArchiveDateToNow(){
        self.lastArchiveInSeconds = Date().timeIntervalSince1970
    }
   
    
    struct IncomeItem : Codable {
        private var _name : String
        var name : String {
            get{
                return _name
            }
            set (value){
                _name = value.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        var amount : Double
        
        init(){
            self._name = String()
            self.amount = 0.0
            self.name = String()
           
        }
        init(_ name : String, _ amount : Double){
            self._name = String()
            self.amount = amount
            self.name = name
        }
    }
    
}

extension Budget {
    enum CodingKeys: String, CodingKey {
            case id, name, buckets, incomes, transactions, linkedUserIds , lastArchiveInSeconds
        }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(buckets, forKey: .buckets)
        try container.encode(incomes, forKey: .incomes)
        try container.encode(transactions, forKey: .transactions)
        try container.encode(linkedUserIds, forKey: .linkedUserIds)
        try container.encode(lastArchiveInSeconds , forKey: .lastArchiveInSeconds)
        //try container.encode(test, forKey: .test)
    }
    
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        _name = String()
        id = try container.decode(String.self, forKey: .id)
        buckets = (try? container.decode([Bucket].self, forKey: .buckets)) ?? []
        incomes = (try? container.decode([IncomeItem].self, forKey: .incomes)) ?? []
        transactions = (try? container.decode([String:[Transaction]].self, forKey: .transactions)) ?? [:]
        linkedUserIds = (try? container.decode([String].self, forKey: .linkedUserIds)) ?? []
        lastArchiveInSeconds = (try? container.decode(Double.self, forKey: .lastArchiveInSeconds)) ?? Date().timeIntervalSince1970
        name = (try? container.decode(String.self, forKey: .name)) ?? String()
        //test = (try? container.decode(String.self, forKey: .test)) ?? "DUMMY"
    }
}
