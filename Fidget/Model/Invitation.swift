//
//  Invitation.swift
//  Fidget
//
//  Created by Ben Nelson on 3/30/22.
//

import Foundation

struct Invitation : Codable {

    private var senderUsername : String
    private var budgetReferenceId : String
    private var budgetName : String
    
    init(senderUsername : String, budgetReferenceId : String, budgetName : String){
        self.senderUsername = senderUsername
        self.budgetReferenceId = budgetReferenceId
        self.budgetName = budgetName
    }
    
    func getSenderUsername() -> String{
        return self.senderUsername
    }
    
    func getBudgetReferenceID() -> String{
        return self.budgetReferenceId
    }
    
    func getBudgetName() -> String{
        return self.budgetName
    }
    
    
}


extension Invitation {
    enum CodingKeys: String, CodingKey {
            case senderUsername, budgetReferenceId, budgetName
        }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(senderUsername, forKey: .senderUsername)
        try container.encode(budgetReferenceId, forKey: .budgetReferenceId)
        try container.encode(budgetName, forKey: .budgetName)

        //try container.encode(test, forKey: .test)
    }
    
    

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        senderUsername = (try? container.decode(String.self, forKey: .senderUsername)) ?? String()
        budgetReferenceId = (try? container.decode(String.self, forKey: .budgetReferenceId)) ?? String()
        budgetName = (try? container.decode(String.self, forKey: .budgetName)) ?? String()
        //test = (try? container.decode(String.self, forKey: .test)) ?? "DUMMY"
    }
}
