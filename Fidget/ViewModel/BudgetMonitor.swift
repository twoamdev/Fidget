//
//  BudgetMonitor.swift
//  Fidget
//
//  Created by Ben Nelson on 4/11/22.
//

import Foundation

class BudgetMonitor : ObservableObject {
    private var timer : Timer
    private var defaultInterval : Double
    private var currentInterval : Double
    private var timeLastStopped : Date
    
    @Published var interrupt : Bool
    
    init(timeInterval : Double){
        self.timer = Timer()
        self.defaultInterval = timeInterval
        self.currentInterval = timeInterval
        self.timeLastStopped = Date()
        self.interrupt = false
        
    }
    
    func startMonitoring(){
        self.setUpMonitorTimer(self.defaultInterval)
    }
    
    func stopMonitoring(){
        self.timer.invalidate()
    }
    
    func delayMonitoringUntilMidnight(){
        self.timer.invalidate()
        
        //Get new interval
        let newInterval = BudgetDataUtils().getTimeInSecondsFromNowToNextDay()
        self.currentInterval = newInterval
        self.setUpMonitorTimer(self.currentInterval)
        
        
        
        //DEBUG
        let tomorrow = Date().timeIntervalSince1970 + newInterval
        let mydate = Date(timeIntervalSince1970: tomorrow)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YY, MMM d, HH:mm:ss" 

        // Convert Date to String
        let time = dateFormatter.string(from: mydate)
        print("won't interrupt until: \(time)")
         
    }

    private func setUpMonitorTimer(_ timeInterval : Double){
        self.timer.invalidate()
        self.timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true, block: { _ in
            self.interrupt.toggle()
        })
    }
    
    
    
    

}

