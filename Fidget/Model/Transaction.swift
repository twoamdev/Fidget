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
    
    init(){
        self.ownerId = ""
        self.bucketId = ""
        self.merchantName = ""
        self.amount = 0.0
        self.note = ""
        self.timestamp = ""
    }
    
    
    func getDate() -> Date {
        //useing self.date -- encode
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = dateFormatter.date(from: self.timestamp) ?? Date()
        return date
    }
    
    mutating func setDate( _ date : Date){
        //set self.date from given NSDate
        //let dateValue = date.timeIntervalSince1970
        let dateFormatter = DateFormatter()
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT") //Set timezone that you want
        //dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm" //Specify your format that you want
        self.timestamp = dateFormatter.string(from: date)
    }
}
