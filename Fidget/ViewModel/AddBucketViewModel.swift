//
//  AddBucketViewModel.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/16/22.
//

import SwiftUI
import FirebaseAuth

class AddBucketViewModel {
    
    
    
    func createInitialTransaction(_ bucket : Bucket, _ amount : Double) -> Transaction {
        var transaction = Transaction()
        
        if let uid = Auth.auth().currentUser?.uid{
            transaction.amount = amount
            transaction.bucketId = bucket.id
            transaction.merchantName = "None"
            transaction.setDate(Date())
            transaction.note = "Transaction auto-generated when created."
            transaction.ownerId = uid
        }

        return transaction
    }
}
