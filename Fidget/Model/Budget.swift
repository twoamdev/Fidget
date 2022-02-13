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
    
    init(_ budgetName: String, _ buckets : [Bucket], _ incomeItems : [IncomeItem]){
        self.name = budgetName
        self.buckets = buckets
        self.incomes = incomeItems
    }
    
    init(){
        self.name = ""
        self.buckets = []
        self.incomes = []
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
