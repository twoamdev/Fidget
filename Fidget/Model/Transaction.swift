//
//  Transaction.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/15/22.
//

import Foundation

struct Transaction : Codable {
    var id = UUID().uuidString
    var ownerId : String
    var bucketId : String
    var merchantName : String
    var amount : Double
    var note : String
    var timestamp : String
    
    init(){
        self.ownerId = ""
        self.bucketId = ""
        self.merchantName = ""
        self.amount = 0.0
        self.note = ""
        self.timestamp = ""
    }
    
    func getNSDate() -> NSDate {
        //useing self.date -- encode
        return NSDate()
    }
    
    func setDateFromNSDate( _ date : NSDate){
        //set self.date from given NSDate
    }
}
