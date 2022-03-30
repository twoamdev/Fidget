//
//  Invitation.swift
//  Fidget
//
//  Created by Ben Nelson on 3/30/22.
//

import Foundation

struct Invitation : Codable {

    private var sender : String
    private var recipient : String
    private var budgetReferenceId : String
    
    init(senderUID : String, recipientUID : String, _ budgetReferenceId : String){
        self.sender = senderUID
        self.recipient = recipientUID
        self.budgetReferenceId = budgetReferenceId
    }
    
    func getSenderUID() -> String{
        return self.sender
    }
    
    func getRecipientUID() -> String{
        return self.recipient
    }
    
    func getBudgetReferenceID() -> String{
        return self.budgetReferenceId
    }
    
    
}
