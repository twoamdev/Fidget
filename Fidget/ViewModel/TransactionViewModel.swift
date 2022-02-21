//
//  TransactionViewModel.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/19/22.
//

import SwiftUI

class TransactionViewModel : ObservableObject {
    @Published var userIdToUsernameMap : [String : String]
    
    init(_ transactions : [Transaction]){
        self.userIdToUsernameMap = [:]
        self.cacheUsernames()
    }
    
    func cacheUsernames(){
        
    }
}

