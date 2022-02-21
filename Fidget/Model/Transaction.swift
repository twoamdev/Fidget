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
    private var timestamp : String
    
    init(_ ownerUserId : String, _ bucketId : String, _ merchantName : String, _ amount : Double, _ notes : String){
        self.ownerId = ownerUserId
        self.bucketId = bucketId
        self.merchantName = merchantName
        self.amount = amount
        self.note = notes
        self.timestamp = ""
        self.setDate(Date())
        
    }
    
    func getDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: self.timestamp) ?? Date()
        return date
    }
    
    private mutating func setDate( _ date : Date){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        self.timestamp = dateFormatter.string(from: date)
    }
}
