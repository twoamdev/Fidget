//
//  BudgetApp.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/23/22.
//

import Foundation

struct Users {
    private(set) var users: Array<User>
    
    init(){
        users = Array<User>()
        let user =  User(firstName: "Benjamin", email: "mrbennelson@gmail.com", password: "HelloWorld2022")
        users.append(user)
    }
    
    mutating func addUser(_ firstName : String, _ lastName: String, _ emailAddress: String, _ password: String){
        let user =  User(firstName: firstName, lastName: lastName, userName: emailAddress, userId: "9192039", email: emailAddress, password: password)
        users.append(user)
       
        print("USERS ----")
        for my_user in users{
            print(my_user)
        }
        print("\n")
    }
    
    struct User {
        var firstName: String = ""
        var lastName: String = ""
        var userName: String = ""
        var userId: String = ""
        var email: String
        var password: String

    }
}
