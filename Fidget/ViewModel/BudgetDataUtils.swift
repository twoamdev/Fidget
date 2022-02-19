//
//  BudgetDataUtils.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/19/22.
//

import SwiftUI

class BudgetDataUtils {
    func calculateBalance(_ transactions : [Transaction], _ bucketId : String) -> Double {
        var balance = 0.0
        for trans in transactions{
            if trans.bucketId == bucketId{
                balance += trans.amount
            }
        }
        return balance
    }
}
