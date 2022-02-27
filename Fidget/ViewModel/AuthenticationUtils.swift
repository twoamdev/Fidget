//
//  AuthenticationUtils.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/31/22.
//

import SwiftUI
import Firebase

class AuthenticationUtils{
    private var db = Firestore.firestore()
    static let maxNameLength : Int = 23
    static let maxUsernameLength : Int = 18
    static let minUsernameLength : Int = 3
    static let maxEmailAddressLocalLength : Int = 32
    static let maxEmailAddressDomainLength : Int = 128
    static let minPasswordLength : Int = 8
    static let maxPasswordLength : Int = 255
    
    func validateName(_ name : String) -> Bool{
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let regEx = "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$"
        let namePred = NSPredicate(format:"SELF MATCHES %@", regEx)
        let valid : Bool = namePred.evaluate(with: trimmedName)
        return valid && !trimmedName.isEmpty && (trimmedName.count <= AuthenticationUtils.maxNameLength)
    }
    
    func validateEmailAddress(_ email: String, _ vm : SignUpViewModel){
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailComponents = trimmedEmail.components(separatedBy: "@")
        var componentsVerified : Bool = (emailComponents.count == 2 ? true : false)
        if componentsVerified{
            let firstComp = emailComponents[0].count <= AuthenticationUtils.maxEmailAddressLocalLength ? true : false
            let secondComp = emailComponents[1].count <= AuthenticationUtils.maxEmailAddressDomainLength ? true : false
            componentsVerified = firstComp && secondComp
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let emailFormatIsCorrect = emailPred.evaluate(with: trimmedEmail) && !trimmedEmail.isEmpty && componentsVerified
        
        if emailFormatIsCorrect{
            //check if it exists on the database
            //Check the database of used Usernames
            let docRef = self.db.collection(DbCollectionA.publicEmails).document(trimmedEmail)
            
            docRef.getDocument { (document, error) in
                guard let document = document, document.exists else {
                    //USERNAME DOESN'T EXIST
                    vm.userInput.emailIsValid = true
                    vm.userInput.emailLoaded()
                    //print("\t-- email doesnt exist")
                    return
                }
               //USERNAME EXISTS
                vm.userInput.emailIsValid = false
                vm.userInput.emailLoaded()
                //print("Email exists")
            }
        }
        else{
            vm.userInput.emailIsValid = false
            vm.userInput.emailLoaded()
        }
    }
    
    func validateUsername(_ username : String, _ vm : SignUpViewModel){
        /*
        No special characters (e.g. @,#,$,%,&,*,(,),^,<,>,!,±)
        Only letters, underscores and numbers allowed
        Length should be 18 characters max and 4 characters minimum
         */
        
        let minLengthString = String(AuthenticationUtils.minUsernameLength)
        let maxLengthString = String(AuthenticationUtils.maxUsernameLength)
        let usernameRegEx = "\\w{\(minLengthString),\(maxLengthString)}"
        let usernamePred = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        let usernameFormatIsCorrect = usernamePred.evaluate(with: username)
        if username.count >= AuthenticationUtils.minUsernameLength && username.count <= AuthenticationUtils.maxUsernameLength{
            vm.userInput.usernameLengthIsValid = true
        }
        else{
            vm.userInput.usernameLengthIsValid = false
        }
        
        let charRegEx = "\\w{1,1000}"
        vm.userInput.usernameCharsAreValid = NSPredicate(format:"SELF MATCHES %@", charRegEx).evaluate(with: username)
        
        
        if username.isEmpty || !usernameFormatIsCorrect{
            vm.userInput.usernameIsValid = false
            vm.userInput.usernameLoaded()
        }
        else{
            
            //Check the database of used Usernames
            let docRef = self.db.collection(DbCollectionA.publicUsernames).document(username)
            
            docRef.getDocument { (document, error) in
                guard let document = document, document.exists else {
                    //USERNAME DOESN'T EXIST
                    vm.userInput.usernameIsValid = true
                    vm.userInput.usernameLoaded()
                    //print("\t-- username doesnt exist")
                    return
                }
               //USERNAME EXISTS
                vm.userInput.usernameIsValid = false
                vm.userInput.usernameLoaded()
                //print("Username exists")
            }
             
        }

    }
    
    func validatePassword(_ password: String, _ vm : SignUpViewModel) -> Bool{
        /*
         Minimum 8 characters at least 1 Alphabet and 1 Number:
         "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
         
         Minimum 8 characters at least 1 Alphabet, 1 Number and 1 Special Character:
         "^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{8,}$"
         
         Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number:
         "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
         
         Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
         "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[d$@$!%*?&#])[A-Za-z\\dd$@$!%*?&#]{8,}"
         
         Minimum 8 and Maximum 10 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet, 1 Number and 1 Special Character:
         "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&#])[A-Za-z\\d$@$!%*?&#]{8,10}"
         
         */
        
        //Minimum 8 characters at least 1 Uppercase Alphabet, 1 Lowercase Alphabet and 1 Number
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        vm.userInput.passwordHasEnoughChars = trimmedPassword.count >= AuthenticationUtils.minPasswordLength ? true : false
        
        let hasUpper = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: trimmedPassword)
        let hasLower = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: trimmedPassword)
        vm.userInput.passwordHasUpperAndLower = hasUpper && hasLower
        
        let hasNumber = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: trimmedPassword)
        vm.userInput.passwordHasNumber = hasNumber
        
        
        
        let minPasswordLengthString = String(AuthenticationUtils.minPasswordLength)
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{\(minPasswordLengthString),}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password) && (password.count <= AuthenticationUtils.maxPasswordLength)
    }
    
}
