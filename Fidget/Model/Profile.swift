//
//
//  Fidget
//
//  Created by Benjamin Nelson on 1/23/22.
//

import Foundation

struct Profile : Codable {
    let firstName : String
    let lastName : String
    let username: String
    let usernameIsSet: Bool
    let emailAddress : String
    
    init(){
        self.firstName = ""
        self.lastName = ""
        self.username = ""
        self.usernameIsSet = false
        self.emailAddress = ""
    }
    
    init(_ firstName: String, _ lastName: String, _ username : String, _ usernameIsSet : Bool, _ emailAddress : String){
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.usernameIsSet = usernameIsSet
        self.emailAddress = emailAddress
    }
    
}
