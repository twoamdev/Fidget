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
    
}
