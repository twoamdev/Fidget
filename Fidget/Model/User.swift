//
//
//  Fidget
//
//  Created by Benjamin Nelson on 1/23/22.
//

import Foundation

struct User : Codable {
    
    var sharedInfo : SharedData
    var privateInfo : PrivateData
    
    init(){
        self.sharedInfo = SharedData(String(), String(), String())
        self.privateInfo = PrivateData(String())
    }
    
    init(_ firstName: String, _ lastName: String, _ username : String, _ emailAddress : String){
        self.sharedInfo = SharedData(firstName, lastName, username)
        self.privateInfo = PrivateData(emailAddress)
    }
    
    init(_ privateData : PrivateData, _ sharedData : SharedData){
        self.sharedInfo = sharedData
        self.privateInfo = privateData
    }

    
    struct PrivateData : Codable {
        private var _emailAddress : String
        var emailAddress : String {
            get{
                return _emailAddress
            }
            set (value){
                _emailAddress = value.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        var budgetLinker : BudgetLink
        
        init( _ emailAddress : String){
            self.budgetLinker = BudgetLink()
            self._emailAddress = String()
            self.emailAddress = emailAddress
        }
    }
    
    struct SharedData : Codable {
        var firstName : String
        var lastName : String
        var username : String
        
        init(_ firstName : String, _ lastName : String , _ username : String){
            self.firstName = firstName
            self.lastName = lastName
            self.username = username
        }
    }
    
    struct BudgetLink : Codable {
        var referenceIds : [String]
        var selectedIdIndex : Int
        
        init(_ ids : [String], _ index : Int){
            self.referenceIds = ids
            self.selectedIdIndex = index
        }
        
        init(){
            self.referenceIds = []
            self.selectedIdIndex = 0
        }
        
        func getSelectedRefId() -> String{
            if self.referenceIds.isEmpty || self.selectedIdIndex >= self.referenceIds.count {
                return String()
            }
            else{
                return self.referenceIds[self.selectedIdIndex]
            }
        }
    }
    
}

