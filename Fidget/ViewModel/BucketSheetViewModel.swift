//
//  BucketSheetViewModel.swift
//  Fidget
//
//  Created by Ben Nelson on 3/26/22.
//

import SwiftUI

class BucketSheetViewModel : ObservableObject {
    @Published var bucket : Bucket = Bucket()
    @Published var transactions : [Transaction] = []
    
    @Published var spendCapacityString = String()
    @Published var prevSpendCapacityString = String()
    
    @Published var bucketChanged = false
    @Published var transactionsChanged = false
    
    private var transactionIds : [String] = []
    
    private func setSpendCapacity(_ capacity : Double){
        self.spendCapacityString = FormatUtils.encodeToNumberLegibleFormat(String(capacity), killDecimal: true)
        self.prevSpendCapacityString = self.spendCapacityString
    }
    
    func initializeSheet(_ bucket : Bucket, _ transactions: [Transaction]){
        self.bucketChanged = false
        self.transactionsChanged = false
        self.transactionIds = []
        
        self.bucket = bucket
        self.transactions = transactions
        self.setSpendCapacity(self.bucket.capacity)
    }
    
    func removeTransaction(offsets : IndexSet, index : Int){
        let trans = self.transactions[index]
        print("remove transaction with amount : \(trans.amount)")
        self.transactionIds.append(trans.id)
        self.transactions.remove(atOffsets: offsets)
    }
    
    func getTransactionIdsToRemove() -> [String]{
        return self.transactionIds
    }
}


