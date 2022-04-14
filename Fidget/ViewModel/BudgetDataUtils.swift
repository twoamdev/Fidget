//
//  BudgetDataUtils.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/19/22.
//

import SwiftUI
import Firebase

class BudgetDataUtils {
    
    func loadBucketNames(_ buckets : [Bucket]) -> [String : String]{
        var bucketNames : [String : String] = [:]
        for myBucket in buckets{
            let id = myBucket.id
            let name = myBucket.name
            bucketNames[name] = id
        }
        return bucketNames
    }
    
    
    func calculateBalance(_ transactions : [Transaction], _ bucketId : String) -> Double {
        var balance = 0.0
        for trans in transactions{
            if trans.bucketId == bucketId{
                balance += trans.amount
            }
        }
        return balance
    }
    
    func createInitialTransaction(_ bucket : Bucket, _ amount : Double) -> Transaction {
        var ownerId = ""
        if let uid = Auth.auth().currentUser?.uid{
            ownerId = uid
        }
        return Transaction(ownerId, bucket.id, "", amount, "")
    }
    
    func sortTransactionsFromNewestToOldest(_ transactions : [Transaction]) -> [Transaction]{
        var myTransactions = transactions
        myTransactions.sort(by: { $0.getDate().timeIntervalSince1970 > $1.getDate().timeIntervalSince1970 })
        return myTransactions
    }
    
    func formatDateAsSimpleTimeSinceNow(_ date : Date) -> String{
        let nowSeconds = Date().timeIntervalSince1970
        let timestampSeconds = date.timeIntervalSince1970
        let resultSeconds : Int =  Int(nowSeconds - timestampSeconds)
        let (hours,mins,_) = secondsToHoursMinutesSeconds(resultSeconds)
        let days = Int(Double(hours) / 24.0)
        let weeks = Int(Double(days) / 7.0)
        let months = Int(Double(weeks) / 4.0)
        let years = Int(Double(weeks) / 52.0)
        
        var timeline = "time unknown"
        
        if years >= 2{
            timeline = "About \(years) years ago"
        }
        else if months >= 1{
            timeline = months == 1 ? "\(months) month ago" : "\(months) months ago"
        }
        else if weeks >= 1{
            timeline = weeks == 1 ? "\(weeks) week ago" : "\(weeks) weeks ago"
        }
        else if days >= 1{
            timeline = days == 1 ? "\(days) day ago" : "\(days) days ago"
        }
        else if hours >= 1{
            timeline = hours == 1 ? "\(hours) hr ago" : "\(hours) hrs ago"
        }
        else if mins >= 1{
            timeline = mins == 1 ? "\(mins) min ago" : "\(mins) mins ago"
        }
        else{
            timeline = "just now"
        }
        
        return timeline
    }
    
    private func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func getYearAndMonthFromTimeInSecondsSince1970(_ time : Double) -> (year : Int, month : Int){
        let date = Date(timeIntervalSince1970: time)
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.year, .month], from: date)
        let year : Int = comp.year ?? -1
        let month : Int = comp.month ?? -1
        return (year, month)
    }
    
    func getTimeInSecondsFromNowToNextDay() -> Double {
        let currentTimeInSeconds = Date().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: currentTimeInSeconds)
        let calendar = Calendar.current
        let comp = calendar.dateComponents([.day, .hour, .minute, .second], from: date)
        let hour = comp.hour ?? -1
        let minute = comp.minute ?? -1
        let second = comp.second ?? -1
        
        let elapsedTime = ((hour * 60) * 60) + (minute * 60) + second

        let standardDayInSeconds = 86400 + 1
        let timeToNextDay : Double = Double(standardDayInSeconds - elapsedTime)
        
        return timeToNextDay
    }
    
    func getPreviousMonth(year: Int , month: Int) -> String{
        if month == 1{
            let prevYear = year - 1
            let prevMonth = 12
            
            return "\(prevYear)_\(prevMonth)"
        }
        else{
            let currYear = year
            let prevMonth = month - 1
            
            var prevMonthString = String(prevMonth)
            prevMonthString = prevMonthString.count == 1 ? "0\(prevMonthString)" : prevMonthString
            
            return "\(currYear)_\(prevMonthString)"
        }
    }
}
