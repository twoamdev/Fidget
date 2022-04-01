//
//  AuthenticationUtils.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/31/22.
//

import SwiftUI
import Firebase

@MainActor class ValidationUtils{
    private var db = Firestore.firestore()
    static let minNameLength : Int = 1
    static let maxNameLength : Int = 23
    static let maxUsernameLength : Int = 18
    static let minUsernameLength : Int = 3
    static let maxEmailAddressLocalLength : Int = 32
    static let maxEmailAddressDomainLength : Int = 128
    static let minPasswordLength : Int = 8
    static let maxPasswordLength : Int = 255
    
    private let specialChars : String = "~@#$%^&*+=`\'|{}:;!.,?\"()\\[\\]\\-"
    
    func validateNameWithWhiteSpaces(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .newlines)
        let regEx = "[A-Za-z ]{\(ValidationUtils.minNameLength),\(ValidationUtils.maxNameLength)}"
        let namePred = NSPredicate(format:"SELF MATCHES %@", regEx)
        let valid : Bool = namePred.evaluate(with: trimmedName)
        return valid
    }
    
    
    
    func validateName(_ name : String) -> Bool{
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let regEx = "[A-Za-z]{\(ValidationUtils.minNameLength),\(ValidationUtils.maxNameLength)}"
        let namePred = NSPredicate(format:"SELF MATCHES %@", regEx)
        let valid : Bool = namePred.evaluate(with: trimmedName)
        return valid
    }
    
    func validateEmailAddressFormat(_ email : String) -> Bool{
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailComponents = trimmedEmail.components(separatedBy: "@")
        var componentsVerified : Bool = (emailComponents.count == 2 ? true : false)
        if componentsVerified{
            let firstComp = emailComponents[0].count <= ValidationUtils.maxEmailAddressLocalLength ? true : false
            let secondComp = emailComponents[1].count <= ValidationUtils.maxEmailAddressDomainLength ? true : false
            componentsVerified = firstComp && secondComp
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let emailFormatIsCorrect = emailPred.evaluate(with: trimmedEmail) && !trimmedEmail.isEmpty && componentsVerified
        return emailFormatIsCorrect
    }
    
    func validateEmailAddress(_ email: String, _ vm : SignUpViewModel){
        
        
        if validateEmailAddressFormat(email) {
            //check if it exists on the database
            //Check the database of used Usernames
            let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
            let docRef = self.db.collection(DBCollectionLabels.publicEmails).document(trimmedEmail)
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
    
    func validateUsername(_ username : String, completion: @escaping (UsernameCheckBundle) -> Void){
        /*
        No special characters (e.g. @,#,$,%,&,*,(,),^,<,>,!,±)
        Only letters, underscores and numbers allowed
        Length should be 18 characters max and 4 characters minimum
         */
        
        var lengthIsValid = false
        var charsAreValid = false
        var usernameIsValid = false
        
        let minLengthString = String(ValidationUtils.minUsernameLength)
        let maxLengthString = String(ValidationUtils.maxUsernameLength)
        let usernameRegEx = "\\w{\(minLengthString),\(maxLengthString)}"
        let usernamePred = NSPredicate(format:"SELF MATCHES %@", usernameRegEx)
        let usernameFormatIsCorrect = usernamePred.evaluate(with: username)
        if username.count >= ValidationUtils.minUsernameLength && username.count <= ValidationUtils.maxUsernameLength{
            lengthIsValid = true
        }
        else{
            lengthIsValid = false
        }
        
        let charRegEx = "\\w{1,1000}"
        charsAreValid = NSPredicate(format:"SELF MATCHES %@", charRegEx).evaluate(with: username)
        
        
        if username.isEmpty || !usernameFormatIsCorrect{
            usernameIsValid = false
            completion(UsernameCheckBundle(lengthValidity: lengthIsValid, charValidity: charsAreValid, usernameValidity: usernameIsValid))
        }
        else{
            
            //Check the database of used Usernames
            let docRef = self.db.collection(DBCollectionLabels.publicUsernames).document(username)
            docRef.getDocument { (document, error) in
                if let document = document, document.exists{
                    //USERNAME EXISTS, therefore already taken
                    usernameIsValid = false
                }
                else{
                   //Username is free to take
                    usernameIsValid = true
                }
                completion(UsernameCheckBundle(lengthValidity: lengthIsValid, charValidity: charsAreValid, usernameValidity: usernameIsValid))
            }
             
        }
    }
    
    func validatePasswordFormat(_ password : String) -> Bool{
        return passwordIsFullyValid(password)
    }
    
    func validatePassword(_ password: String, _ vm : SignUpViewModel) -> Bool{
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        vm.userInput.passwordHasEnoughChars = passwordHasEnoughChars(trimmedPassword)
        vm.userInput.passwordHasUpperAndLower = passwordHasUpperCase(trimmedPassword) && passwordHasLowerCase(trimmedPassword)
        vm.userInput.passwordHasNumber = passwordHasNumber(trimmedPassword)
        vm.userInput.passwordHasValidOptionalSpecialChars = passwordHasSpecialChars(trimmedPassword)
        return passwordIsFullyValid(trimmedPassword)
    }
    
    private func passwordHasEnoughChars(_ password : String) -> Bool{
        return password.count >= ValidationUtils.minPasswordLength ? true : false
    }
    
    private func passwordHasUpperCase(_ password : String) -> Bool{
        return NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password)
    }
    
    private func passwordHasLowerCase(_ password : String) -> Bool{
        return NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password)
    }
    
    private func passwordHasNumber(_ password : String) -> Bool{
        return NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)
    }
    
    private func passwordHasSpecialChars(_ password : String) -> Bool{
        let chars = self.specialChars
        return NSPredicate(format: "SELF MATCHES %@", ".*[\(chars)]+.*").evaluate(with: password)
    }
    
    private func passwordIsFullyValid(_ password : String) -> Bool {
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
        let minPasswordLengthString = String(ValidationUtils.minPasswordLength)
        let specialCharsRegex = "[\\w\(self.specialChars)]"
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]\(specialCharsRegex){\(minPasswordLengthString),}$"
        return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password) && (password.count <= ValidationUtils.maxPasswordLength)
    }
}

struct UsernameCheckBundle {
    var lengthIsValid : Bool
    var charsAreValid : Bool
    var usernameIsValid : Bool
    
    init(lengthValidity : Bool, charValidity : Bool, usernameValidity : Bool){
        self.lengthIsValid = lengthValidity
        self.charsAreValid = charValidity
        self.usernameIsValid = usernameValidity
    }
}
