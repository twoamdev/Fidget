//
//  Bucket.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/6/22.
//

import Foundation

struct Bucket : Codable {
    var name: String
    var value: Double
    var capacity: Double
    var rolloverEnabled : Bool
    
    init(){
        self.name = "Empty Bucket"
        self.value = 0.0
        self.capacity = 0.0
        self.rolloverEnabled = false
        
    }
    
    init(name: String, value: Double, capacity: Double, rollover: Bool){
        self.name = name
        self.value = value
        self.capacity = capacity
        self.rolloverEnabled = rollover
        
    }
    
    /*
    init(firestoreBucket : Any){
        let data : [String : Any] = firestoreBucket as? [String : Any] ?? [:]
        self.name =  data["name"] as? String ?? ""
        self.value = data["value"] as? Double ?? 0.0
        self.capacity = data["capacity"] as? Double ?? 0.0
        self.rolloverEnabled = data["rolloverEnabled"] as? Bool ?? false
    }
    
    func encodeBucket() ->[String : Any]{
        let encoding : [String : Any] = ["name" : self.name,
                                         "value" : self.value,
                                         "capacity" : self.capacity,
                                         "rolloverEnabled" : self.rolloverEnabled ]
        return encoding
    }
     */
}
