//
//
//  Fidget
//
//  Created by Benjamin Nelson on 1/23/22.
//

import Foundation

struct Profile {
    let firstName : String
    let lastName : String
    let username: String
    let emailAddress : String
    
    init(){
        self.firstName = ""
        self.lastName = ""
        self.username = ""
        self.emailAddress = ""
    }
    
    init(_ firstName: String, _ lastName: String, _ username : String, _ emailAddress : String){
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.emailAddress = emailAddress
    }
    
}
