//
//  DatabaseUtils.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/2/22.
//

import Foundation

enum DatabaseCollectionLabels : String {
    
    //COLLECTIONS
    case users = "users"
    
    //USER PROFILE DOCUMENT FIELDS
    case firstName = "firstName"
    case lastName = "lastName"
    case username = "username"
    case emailAddress = "emailAddress"
}

struct DatabaseLabels{
    let users = DatabaseCollectionLabels.users.rawValue
}

struct ProfileLabels{
    let firstName = DatabaseCollectionLabels.firstName.rawValue
    let lastName = DatabaseCollectionLabels.lastName.rawValue
    let username = DatabaseCollectionLabels.username.rawValue
    let emailAddress = DatabaseCollectionLabels.emailAddress.rawValue
}

