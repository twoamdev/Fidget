//
//  Bucket.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/6/22.
//

import Foundation

struct Bucket : Codable {
    var id = UUID().uuidString
    var name: String
    var capacity: Double
    var rolloverCapacity : Double
    var rolloverEnabled : Bool
    
    init(){
        self.name = "Empty Bucket"
        self.capacity = 0.0
        self.rolloverCapacity = 0.0
        self.rolloverEnabled = false
        
    }
    
    init(name: String, capacity: Double, rollover: Bool){
        self.name = name
        self.capacity = capacity
        self.rolloverCapacity = 0.0
        self.rolloverEnabled = rollover
    }
}
