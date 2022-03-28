//
//  BucketSheetViewModel.swift
//  Fidget
//
//  Created by Ben Nelson on 3/26/22.
//

import SwiftUI

class BucketSheetViewModel : ObservableObject {
    @Published private var bucket : Bucket = Bucket()
    @Published private var balance : Double = .zero
    
    @Published var name = String()
    @Published var spendValue : Double = .zero
    @Published var spendValueString = String()
    @Published var prevSpendValueString = String()
    
    @Published var spendCapacity : Double = .zero
    @Published var spendCapacityString = String()
    @Published var prevSpendCapacityString = String()
    
    @Published var rolloverEnabled : Bool = false
    
    
    func storeCurrentBucketData(_ bucket : Bucket, _ balance : Double){
        self.bucket = bucket
        self.balance = balance
        
        self.name = self.bucket.name
        self.spendCapacity = self.bucket.capacity
        self.rolloverEnabled = self.bucket.rolloverEnabled
        self.spendValueString = FormatUtils.encodeToNumberLegibleFormat(String(self.balance), killDecimal: true)
        self.spendCapacityString = FormatUtils.encodeToNumberLegibleFormat(String(self.bucket.capacity), killDecimal: true)
    }
    
    func editBucketIfNecessary() -> Bool {
        let nameChanged = self.nameChanged()
        let spendCapChanged = self.spendCapacityChanged()
        let rolloverChanged = self.rolloverChanged()
        self.bucket.name = nameChanged ? self.name : self.bucket.name
        self.bucket.capacity = spendCapChanged ? self.spendCapacity : self.bucket.capacity
        self.bucket.rolloverEnabled = rolloverChanged ? self.rolloverEnabled : self.bucket.rolloverEnabled
        
        return (nameChanged || spendCapChanged || rolloverChanged)
    }
    
    func getBucket() -> Bucket{
        return self.bucket
    }
    
    func bucketId() -> String{
        return self.bucket.id
    }
    
    func balanceAmt() -> Double {
        return self.balance
    }
    
    func capacity() -> Double {
        return self.bucket.capacity
    }
    
    private func nameChanged() -> Bool {
        return self.name == self.bucket.name ? false : true
    }
    
    private func spendCapacityChanged() -> Bool {
        return self.spendCapacity == self.bucket.capacity ? false : true
    }
    
    private func rolloverChanged() -> Bool {
        return self.rolloverEnabled == self.bucket.rolloverEnabled ? false : true
    }
}


