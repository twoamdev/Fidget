//
//  UsersViewModel.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/23/22.
//

import SwiftUI
import FirebaseAuth
import Firebase

class SignUpViewModel : ObservableObject {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    @Published var firstNameErrorMessage : String
    @Published var lastNameErrorMessage : String
    @Published var emailErrorMessage : String
    @Published var passwordErrorMessage : String
    @Published var confirmPasswordErrorMessage : String
    @Published var signUpSuccess : Bool
    @Published var showSignUpPage : Bool
    
    init(){
        self.firstNameErrorMessage = ""
        self.lastNameErrorMessage = ""
        self.emailErrorMessage = ""
        self.passwordErrorMessage = ""
        self.confirmPasswordErrorMessage = ""
        self.signUpSuccess = false
        self.showSignUpPage = false
    }
    
    private enum SignUpName : String{
        case firstName = "FIRSTNAME"
        case lastName = "LASTNAME"
        case email = "EMAIL"
        case password = "PASSWORD"
        case passwordConfirm = "PASSWORDCONFIRM"
    }
    
    
    private struct SignUpResult{
        var name : SignUpName
        var valid : Bool
        var message : String
    }
    
    
    
    func signUpUser(_ signUpUserInput : SignUpUserInput) {
        
        let trimmedInput = trimSignUpInput(signUpUserInput)
        let validationResult = validateSignUpInput(trimmedInput)
        let valid = processValidationResult(validationResult)
        if valid {
            createUser(trimmedInput)
        }
        else{
            self.signUpSuccess = false
        }
    }
    
    private func createUser(_ input: SignUpUserInput){
        
        let data = [DatabaseFields().firstName : input.firstName,
                    DatabaseFields().lastName  : input.lastName,
                    DatabaseFields().username : input.email,
                    DatabaseFields().emailAddress : input.email]
        
        auth.createUser(withEmail: input.email, password: input.password){ result, error in
            guard result != nil, error == nil else{
                print("Sign Up Failed with Firebase")
                //let code = error?._code
                let code = (error?.localizedDescription)!
                self.emailErrorMessage = code
                self.signUpSuccess = false
                return
            }

            //Successful sign up
            let uid = (result?.user.uid)!
            print("UID: \(uid)")
            self.signUpSuccess = true
            self.showSignUpPage = false
            self.db.collection(DatabaseCollections().users)
                .document(uid).collection(DatabaseCollections().userData)
                .document(DatabaseDocs().personalInfo).setData(data) { [weak self] err in
                guard self != nil else { return }
                    if let err = err {
                        print("err ... \(err)")
                    }
                    else {
                        try? self?.auth.signOut()
                    }
            }
        }
    }
    
    
    
    
    private func trimSignUpInput(_ userInput : SignUpUserInput) -> SignUpUserInput{
        let trimmedInput = SignUpUserInput(firstName: userInput.firstName.trimmingCharacters(in: .whitespacesAndNewlines),
                                           lastName: userInput.lastName.trimmingCharacters(in: .whitespacesAndNewlines),
                                           email: userInput.email.trimmingCharacters(in: .whitespacesAndNewlines),
                                           password: userInput.password,
                                           confirmPassword: userInput.confirmPassword)
        return trimmedInput
    }
    
    private func validateSignUpInput(_ input: SignUpUserInput) -> Array<SignUpResult>{
        
        var results : Array<SignUpResult> = []
        
        results.append(isValidName(input.firstName, isFirstName: true))
        results.append(isValidName(input.lastName, isFirstName: false))
        results.append(isValidEmail(input.email))
        results.append(isValidPassword(input.password))
        let match = input.password == input.confirmPassword ? true : false
        results.append(SignUpResult(name : SignUpName.passwordConfirm ,valid: match, message: match ? "" : "Password needs to match the Confirm Password"))
        
        
        return results
    }
    
    private func processValidationResult(_ results : Array<SignUpResult>) -> Bool{
        
        var validation = true
        for result in results {
            //global return valid or not
            if !result.valid && validation{
                validation = false
            }
            //Set error messages
            
            self.firstNameErrorMessage = result.name == SignUpName.firstName ? result.message : self.firstNameErrorMessage
            self.lastNameErrorMessage = result.name == SignUpName.lastName ? result.message : self.lastNameErrorMessage
            self.emailErrorMessage = result.name == SignUpName.email ? result.message : self.emailErrorMessage
            self.passwordErrorMessage = result.name == SignUpName.password ? result.message : self.passwordErrorMessage
            self.confirmPasswordErrorMessage = result.name == SignUpName.passwordConfirm ? result.message : self.confirmPasswordErrorMessage
            
        }
        return validation
    }

    private func isValidName(_ name: String, isFirstName: Bool) -> SignUpResult {
        let regEx = "^(([^ ]?)(^[a-zA-Z].*[a-zA-Z]$)([^ ]?))$"

        let namePred = NSPredicate(format:"SELF MATCHES %@", regEx)
        let valid : Bool = namePred.evaluate(with: name)
        let nameType = isFirstName ? "first name" : "last name"
        let message = valid == true ? "" : "Must enter a valid \(nameType)"
        return SignUpResult(name: isFirstName ? SignUpName.firstName :  SignUpName.lastName,valid: valid, message: message)
        
    }
    
    private func isValidEmail(_ email: String) -> SignUpResult {
        let valid : Bool = AuthenticationUtils().isValidEmailAddress(email)
        let message = valid ? "" : "Must enter a valid email address"
        return SignUpResult(name: SignUpName.email,valid: valid, message: message)
    }
    
    private func isValidPassword(_ password: String) -> SignUpResult {
        let valid = AuthenticationUtils().isValidPassword(password)
        let message = valid == true ? "" : "Password requries: Minimum of 8 characters, at least 1 Uppercase and 1 Lowercase letter, and 1 number"
        return SignUpResult(name: SignUpName.password, valid: valid, message: message)
    }
}

