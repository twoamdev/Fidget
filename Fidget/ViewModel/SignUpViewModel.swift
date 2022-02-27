//
//  UsersViewModel.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/23/22.
//

import SwiftUI
import FirebaseAuth
import Firebase
import Combine

class SignUpViewModel : ObservableObject {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    @Published var userInput = SignUpUserInput()
    @Published var userSignUpStatus = SignUpStatus()
    
    func validateFirstName(_ firstName : String){
        self.userInput.firstNameIsValid = AuthenticationUtils().validateName(firstName)
    }
    
    func validateLastName(_ lastName : String){
        self.userInput.lastNameIsValid = AuthenticationUtils().validateName(lastName)
    }
    
    func validateUsername(_ username : String){
        AuthenticationUtils().validateUsername(username, self)
    }
    
    func validateEmailAddress(_ email : String){
        AuthenticationUtils().validateEmailAddress(email, self)
    }
    
    func validatePassword(_ password : String){
        self.userInput.passwordIsValid = AuthenticationUtils().validatePassword(password, self)
    }
    
    func validateConfirmationPassword(_ password : String){
        self.userInput.passwordConfirmIsValid = self.userInput.password == self.userInput.confirmPassword ? true : false
    }
    
    func signUpUser() {
        if self.userInput.allAreValid() {
            self.userSignUpStatus.accountIsProcessing = true
            self.createUserAccount()
        }
    }
     
    private func createUserAccount(){
        let email = self.userInput.email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = self.userInput.password
        
        let firstName = self.userInput.firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = self.userInput.lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        let username = self.userInput.username.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let userProfile = User(firstName, lastName, username , email)
        
        self.userInput.resetInput()
        
        self.auth.createUser(withEmail: email, password: password, completion: { (result, err) in
            if err == nil{
                self.userSignUpStatus.createUserStatus(true)
                if let uid = result?.user.uid{
                    
                    self.setPrivateUserData(uid, userProfile)
                    self.setSharedUserData(uid, userProfile)
                    self.setPublicData(email: email, username: username)
                    
                }
            }
            else{
                self.userSignUpStatus.createUserStatus(false)
                print(err ?? "error on user creation")
            }
        })
    }
    
    private func setPrivateUserData(_ uid : String, _ userProfile : User){
        do{
            try self.db.collection(DbCollectionA.users).document(uid).setData(from: userProfile.privateInfo)
            self.userSignUpStatus.storePrivateUserDataStatus(true)
        }
        catch{
            self.userSignUpStatus.storePrivateUserDataStatus(false)
            print(error)
        }
    }
    
    private func setSharedUserData(_ uid : String, _ userProfile : User){
        do{
            try self.db.collection(DbCollectionA.sharedData).document(uid).setData(from: userProfile.sharedInfo)
            self.userSignUpStatus.storeSharedUserDataStatus(true)
        }
        catch{
            self.userSignUpStatus.storeSharedUserDataStatus(false)
            print(error)
        }
    }
    
    private func setPublicData(email : String, username : String){
        do{
            self.db.collection(DbCollectionA.publicEmails).document(email).setData([:])
            self.db.collection(DbCollectionA.publicUsernames).document(username).setData([:])
            self.userSignUpStatus.storePublicDataStatus(true)
        }
    }
}

struct SignUpStatus{
    var accountIsProcessing = false
    private var createdUserSuccess = false
    private var storedUserPrivateInfoSuccess = false
    private var storedUserSharedInfoSuccess = false
    private var storedPublicDataSuccess = false
    
    func success() -> Bool {
        return self.createdUserSuccess && self.storedUserPrivateInfoSuccess && self.storedUserSharedInfoSuccess && self.storedPublicDataSuccess
    }
    
    mutating func createUserStatus(_ status : Bool){
        self.createdUserSuccess = status
    }
    
    mutating func storePrivateUserDataStatus(_ status : Bool){
        self.storedUserPrivateInfoSuccess = status
    }
    
    mutating func storeSharedUserDataStatus(_ status : Bool){
        self.storedUserSharedInfoSuccess = status
    }
    
    mutating func storePublicDataStatus(_ status : Bool){
        self.storedPublicDataSuccess = status
    }
}



struct SignUpUserInput{
    
    var firstName = String()
    var lastName = String()
    var username = String()
    var email = String()
    var password = String()
    var confirmPassword = String()
    var firstNameIsValid = false
    var lastNameIsValid = false
    var usernameIsValid = false
    var usernameLengthIsValid = false
    var usernameCharsAreValid = false
    var emailIsValid = false
    var passwordIsValid = false
    var passwordHasEnoughChars = false
    var passwordHasUpperAndLower = false
    var passwordHasNumber = false
    var passwordConfirmIsValid = false
    var usernameLoading = false
    var emailLoading = false

    
    func allAreValid() -> Bool{
        if firstNameIsValid && lastNameIsValid && usernameIsValid && emailIsValid && passwordIsValid && passwordConfirmIsValid{
            return true
        }
        else{
            return false
        }
    }
    
    mutating func usernameIsLoading(){
        self.usernameLoading = true
    }
    
    mutating func usernameLoaded(){
        self.usernameLoading = false
    }
    
    mutating func emailIsLoading(){
        self.emailLoading = true
    }
    
    mutating func emailLoaded(){
        self.emailLoading = false
    }
    
    mutating func resetInput(){
        self.firstName = String()
        self.lastName = String()
        self.username = String()
        self.email = String()
        self.password = String()
        self.confirmPassword = String()
        self.firstNameIsValid = false
        self.lastNameIsValid = false
        self.usernameIsValid = false
        self.usernameCharsAreValid = false
        self.usernameLengthIsValid = false
        self.emailIsValid = false
        self.passwordIsValid = false
        self.passwordHasEnoughChars = false
        self.passwordHasUpperAndLower = false
        self.passwordHasNumber = false
        self.passwordConfirmIsValid = false
        self.usernameLoading = false
        self.emailLoading = false
    }
}

class TextFieldObserver : ObservableObject {
    @Published var debouncedText = ""
    @Published var searchText = ""
            
        init(delay: DispatchQueue.SchedulerTimeType.Stride) {
            self.$searchText
                .debounce(for: delay, scheduler: DispatchQueue.main)
                .assign(to: &self.$debouncedText)
        }
}
