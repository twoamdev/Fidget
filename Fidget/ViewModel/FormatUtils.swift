//
//  FormatUtils.swift
//  Fidget
//
//  Created by Ben Nelson on 3/19/22.
//

import SwiftUI

struct FormatUtils {

    static let maxNumberDigitLength : Int = 9
    static let maxDecimalLength : Int = 2
    static let maxBucketNameLimit : Int  = 19
    static let maxBudgetNameLimit : Int = 24
    static let maxIncomeNameLimit : Int = 24
    
    
    static func usernameFormat(_ value : String) -> (String, String){
        var username = value
        if value == "@"{
            username = ""
        }
        else{
            if value.count == 1{
                username = "@" + value
            }
        }
        //don't allow spaces
        username = username.replacingOccurrences(of: " ", with: "")
        
        let rawUsername = username.replacingOccurrences(of: "@", with: "")
        return (username, rawUsername)
    }
    
    
    static func validateNumberFormat(_ value : String) -> Bool{
        let regEx = "^[0-9]{0,\(FormatUtils.maxNumberDigitLength)}(\\.[0-9]{0,\(FormatUtils.maxDecimalLength)})?$"
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        let result = pred.evaluate(with: value)
        return result
    }
    
    static func decodeFromNumberLegibleFormat(_ value : String) -> String{
        
        var decoded = value.replacingOccurrences(of: "$", with: "")
        decoded = decoded.replacingOccurrences(of: ",", with: "")
        decoded = decoded.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return decoded
    }
    
    static func encodeToNumberLegibleFormat(_ value : String, killDecimal : Bool = false) -> String{
        
        if value.isEmpty{
            return String()
        }
        
        if value.contains("."){
            let split = value.split(separator: ".")
            var edit : String = String(split[0])
            edit = formatNumberStringWithCommas(edit)
            if split.count > 1 {
                if killDecimal && String(split[1]) == "0" {
                    
                }
                else{
                    edit = edit + "." + String(split[1])
                }
            }
            else{
                edit = edit + "."
            }
            return "$\(edit)"
        }
        else{
            return "$\(formatNumberStringWithCommas(value))"
        }
    }
    
    
    static func formatNumberStringForUserAndValue(_ numberHelper : NumberFormatterHelper){
        if !numberHelper.userInputText.isEmpty{
            let checkValue = FormatUtils.decodeFromNumberLegibleFormat(numberHelper.userInputText)
            let formatIsCorrect = FormatUtils.validateNumberFormat(checkValue)
            
            if formatIsCorrect{
                numberHelper.displayText = checkValue.isEmpty ? String() : FormatUtils.encodeToNumberLegibleFormat(checkValue)
                numberHelper.prevDisplayText = numberHelper.displayText
                numberHelper.numberValue = Double(checkValue) ?? .zero
            }
            else{
                let decoded = FormatUtils.decodeFromNumberLegibleFormat(numberHelper.prevDisplayText)
                numberHelper.displayText = decoded.isEmpty ? String() : FormatUtils.encodeToNumberLegibleFormat(decoded)
            }
        }
    }
    
    static private func formatNumberStringWithCommas(_ value : String) -> String{
        //should be a none decimal value string ex: 10293 or 0003
        var numberString = String(Int(value) ?? 0)
        if numberString.count > 3{
            var count = 0
            let reverse = numberString.reversed()
            var updated = String()
            for char in reverse{
                if count % 3 == 0 && count != 0{
                    updated += ","
                }
                updated += String(char)
                count += 1
            }
            numberString = String(updated.reversed())
        }
        return numberString
    }
    
    static func getCurrentMonth() -> String {
        let date = Date() // get a current date instance
        let dateFormatter = DateFormatter() // get a date formatter instance
        let calendar = dateFormatter.calendar // get a calendar instance
        let month = calendar?.component(.month, from: date) ?? 0
        let monthsWithFullName = dateFormatter.monthSymbols
        let monthString = monthsWithFullName?[month-1] ?? "Month"
        return monthString
    }
}

class NumberFormatterHelper {
    var userInputText : String
    var displayText : String
    var prevDisplayText : String
    var numberValue : Double
    
    init(_ inputText: String, _ displayText : String, _ prevDisplayText : String, _ numberValue : Double){
        self.userInputText = inputText
        self.displayText = displayText
        self.prevDisplayText = prevDisplayText
        self.numberValue = numberValue
    }
}
