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
    
    static func encodeToNumberLegibleFormat(_ value : String) -> String{
        //0012
        //1020
       
        
        if value.isEmpty{
            return String()
        }
        
        if value.contains("."){
            let split = value.split(separator: ".")
            var edit : String = String(split[0])
            edit = formatNumberStringWithCommas(edit)
            if split.count > 1 {
                edit = edit + "." + String(split[1])
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
}
