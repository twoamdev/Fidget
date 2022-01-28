//
//  UsersViewModel.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/23/22.
//

import SwiftUI
import FirebaseAuth

class SignUpViewModel {
    let auth = Auth.auth()
    
    func signUpUser(_ signUpUserInput : SignUpUserInput) -> (Bool,String){
        
        let trimmedInput = trimSignUpInput(signUpUserInput)
        let validationResult = validateSignUpInput(trimmedInput)
        if validationResult.valid{
            
            // Existing USER
            // Bob Vance
            // bob@twoamdev.com
            // HelloWorld2022
            
            
            auth.createUser(withEmail: trimmedInput.email, password: trimmedInput.password){ result, error in
                guard result != nil, error == nil else{
                    print("Sign Up Failed with Firebase")
                    return
                }
                
                //Successful sign up
                print("SIGNED UP: \(trimmedInput)")
                
            }
            
            
        }
        return (validationResult.valid, validationResult.message)
    }
    
    struct SignUpResult{
        var valid : Bool
        var message : String
    }
    
    
    func trimSignUpInput(_ userInput : SignUpUserInput) -> SignUpUserInput{
        let trimmedInput = SignUpUserInput(firstName: userInput.firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                                           lastName: userInput.lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                                           email: userInput.email.trimmingCharacters(in: .whitespacesAndNewlines),
                                           password: userInput.password,
                                           confirmPassword: userInput.confirmPassword)
        return trimmedInput
    }
    
    func validateSignUpInput(_ input: SignUpUserInput) -> SignUpResult{
        
        var results : Array<SignUpResult> = []
        
        results.append(isValidName(input.firstName, isFirstName: true))
        results.append(isValidName(input.lastName, isFirstName: false))
        results.append(isValidEmail(input.email))
        results.append(isValidPassword(input.password))
        let match = input.password == input.confirmPassword ? true : false
        results.append(SignUpResult(valid: match, message: match ? "" : "- Password needs to match the Confirm Password"))
        
        
        var totalValidation : Bool = true
        var totalMessage : String = ""
        for result in results{
            //if any of the inputs are false, set to false
            if !result.valid && totalValidation {
                totalValidation = false
            }
            //append messages
            let appendage : String = result.message == "" ? "" : "\(result.message)\n"
            totalMessage += appendage
        }
        return SignUpResult(valid: totalValidation, message: totalMessage)
    }
    
    func isValidName(_ name: String, isFirstName: Bool) -> SignUpResult {
        let regEx = "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$"

        let namePred = NSPredicate(format:"SELF MATCHES %@", regEx)
        let valid : Bool = namePred.evaluate(with: name)
        let nameType = isFirstName ? "first name" : "last name"
        let message = valid == true ? "" : "- Must enter a valid \(nameType)"
        return SignUpResult(valid: valid, message: message)
        
    }
    
    func isValidEmail(_ email: String) -> SignUpResult {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let valid : Bool = emailPred.evaluate(with: email)
        let message = valid == true ? "" : "- Must enter a valid email address"
        return SignUpResult(valid: valid, message: message)
    }
    
    func isValidPassword(_ password: String) -> SignUpResult {
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
        let passwordRegex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)[a-zA-Z\\d]{8,}$"
        let valid : Bool = NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: password)
        let message = valid == true ? "" : "- Password requries: Minimum of 8 characters, at least 1 Uppercase and 1 Lowercase letter, and 1 number"
        return SignUpResult(valid: valid, message: message)
    }
}

