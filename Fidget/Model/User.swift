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
        private var _firstName : String
        var firstName : String {
            get{
                return _firstName
            }
            set (value){
                _firstName = value.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        private var _lastName : String
        var lastName : String {
            get{
                return _lastName
            }
            set (value){
                _lastName = value.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        private var _username : String
        var username : String {
            get{
                return _username
            }
            set (value){
                _username = value.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        
        init(_ firstName : String, _ lastName : String , _ username : String){
            self._firstName = String()
            self._lastName = String()
            self._username = String()
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

