//
//  Bucket.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/6/22.
//

import Foundation

struct Bucket : Codable {
    var id = UUID().uuidString
    private var _name : String
    var name: String {
        get{
            return _name
        }
        set (value){
            _name = value.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }
    var capacity: Double
    var rolloverCapacity : Double
    var rolloverEnabled : Bool
    
    init(){
        self._name = String()
        self.capacity = 0.0
        self.rolloverCapacity = 0.0
        self.rolloverEnabled = false
        self.name = "Empty Bucket"
        
    }
    
    init(name: String, capacity: Double, rollover: Bool){
        self._name = String()
        self.capacity = capacity
        self.rolloverCapacity = 0.0
        self.rolloverEnabled = rollover
        self.name = name
    }
}
