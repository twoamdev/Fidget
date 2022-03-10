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
    @Published var isProcessingSignUp : Bool = false
    @Published var showHome : Bool = false
 

    
    @MainActor func validateEmailAddress(_ email : String){
        ValidationUtils().validateEmailAddress(email, self)
    }
    
    @MainActor func validatePassword(_ password : String){
        self.userInput.passwordIsValid = ValidationUtils().validatePassword(password, self)
    }
    
    
    func signUpUser() {
        if self.userInput.allAreValid() {
            self.userSignUpStatus.startLoading()
            self.isProcessingSignUp = true
            //self.createUserAccount()
            self.fakeCreateUserAccout()
            self.artificialLoad()
        }
    }
    
    private func fakeCreateUserAccout(){
        print("user signed in")
        self.showHome = true
        self.userSignUpStatus.userCreatedStatus(true)
        self.userSignUpStatus.storePrivateUserDataStatus(true)
        self.isProcessingSignUp = !userSignUpStatus.success()
        self.userSignUpStatus.storeSharedUserDataStatus(true)
        self.isProcessingSignUp = !userSignUpStatus.success()
        self.userSignUpStatus.storePublicDataStatus(true)
        self.isProcessingSignUp = !userSignUpStatus.success()
    }
    
    private func createUserAccount(){
        let email = self.userInput.email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = self.userInput.password
        
        let firstName = String() // self.userInput.firstName.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastName = String() //self.userInput.lastName.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let userProfile = User(firstName, lastName, String() , email)
        
        self.auth.createUser(withEmail: email, password: password, completion: { (result, err) in
            if err == nil{
                self.userSignUpStatus.userCreatedStatus(true)
                
                if let uid = result?.user.uid{
                    print("user signed in")
                    self.showHome = true
                    
                    Task{
                        await self.setPrivateUserData(uid, userProfile)
                        await self.setSharedUserData(uid, userProfile)
                        await self.setPublicData(email: email, username: String())
                    }
                    
                }
            }
            else{
                self.userSignUpStatus.userCreatedStatus(false)
                print(err ?? "error on user creation")
            }
        })
    }
    
    private func setPrivateUserData(_ uid : String, _ userProfile : User) async {
        do{
            try self.db.collection(DbCollectionA.users).document(uid).setData(from: userProfile.privateInfo)
            self.userSignUpStatus.storePrivateUserDataStatus(true)
            self.isProcessingSignUp = !userSignUpStatus.success()
        }
        catch{
            self.userSignUpStatus.storePrivateUserDataStatus(false)
            print(error)
        }
    }
    
    
    private func setSharedUserData(_ uid : String, _ userProfile : User) async {
        do{
            try self.db.collection(DbCollectionA.sharedData).document(uid).setData(from: userProfile.sharedInfo)
            self.userSignUpStatus.storeSharedUserDataStatus(true)
            self.isProcessingSignUp = !userSignUpStatus.success()
        }
        catch{
            self.userSignUpStatus.storeSharedUserDataStatus(false)
            print(error)
        }
    }
    
    private func setPublicData(email : String, username : String) async {
        do{
            try await self.db.collection(DbCollectionA.publicEmails).document(email).setData([:])
            try await self.db.collection(DbCollectionA.publicUsernames).document(username).setData([:])
            self.userSignUpStatus.storePublicDataStatus(true)
            self.isProcessingSignUp = !userSignUpStatus.success()
        }
        catch{
            print(error)
        }
    }
    
    private func artificialLoad(){
        let increment = self.userSignUpStatus.loadTimeInterval()
        Timer.scheduledTimer(withTimeInterval: increment, repeats: true) { timer in
            self.userSignUpStatus.nextPhase()
            if self.userSignUpStatus.phase() == self.userSignUpStatus.maxLoadPhases(){
                self.userSignUpStatus.stopLoading()
                self.isProcessingSignUp = !self.userSignUpStatus.success()
                self.clearSignUpData()
                timer.invalidate()
            }
        }
    }
    
    private func clearSignUpData(){
        self.userSignUpStatus.resetStatus()
        self.userInput.resetInput()
    }
}

struct SignUpStatus{
    private var createdUserSuccess = false
    private var storedUserPrivateInfoSuccess = false
    private var storedUserSharedInfoSuccess = false
    private var storedPublicDataSuccess = false
    private var loadingPhase : Int = .zero
    private let loadingPhaseMax : Int = 3
    private let timeInterval : Double = 2.0 //in seconds
    private var loading = false
     
    func success() -> Bool {
        /*
        print("CREATED USER: \(self.createdUserSuccess)")
        print("STORED PRIVATE: \(self.storedUserPrivateInfoSuccess)")
        print("STORED SHARED: \(self.storedUserSharedInfoSuccess)")
        print("STORED PUBLIC: \(self.storedPublicDataSuccess)")
        print("LOADING: \((!self.loading))")
         */
        return self.createdUserSuccess && self.storedUserPrivateInfoSuccess && self.storedUserSharedInfoSuccess && self.storedPublicDataSuccess && (!self.loading)
    }
    
    mutating func userCreatedStatus(_ status : Bool){
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
    
    func phase() -> Int {
        return self.loadingPhase
    }
    
    mutating func nextPhase(){
        self.loadingPhase += 1
    }
    
    func loadTimeInterval() -> Double{
        return self.timeInterval
    }
    
    func maxLoadPhases() -> Int{
        return self.loadingPhaseMax
    }
    
    func phaseMessage() -> String {
        let phase = self.loadingPhase
        var message = ""
        switch phase{
        case 0:
            message = "Initializing Account."
        case 1:
            message = "Setting Up Cool Stuff."
        case 2:
            message = "Finalizing all details."
        case 3:
            message = "Done."
        default:
            message = "Creating Account"
        }
        return message
    }
    
    mutating func startLoading(){
        self.loadingPhase = .zero
        self.loading = true
    }
    mutating func stopLoading(){
        self.loading = false
    }
    
    func isLoading() -> Bool{
        return self.loading
    }
    
    mutating func resetStatus(){
        self.createdUserSuccess = false
        self.storedUserPrivateInfoSuccess = false
        self.storedUserSharedInfoSuccess = false
        self.storedPublicDataSuccess = false
        self.stopLoading()
    }
}



struct SignUpUserInput{
    var email = String()
    var password = String()
    
    var emailIsValid = false
    var passwordIsValid = false
    
    var passwordHasEnoughChars = false
    var passwordHasUpperAndLower = false
    var passwordHasNumber = false
    var passwordHasValidOptionalSpecialChars = false
    
    var emailLoading = false

    
    func allAreValid() -> Bool{
        if emailIsValid && passwordIsValid{
            return true
        }
        else{
            return false
        }
    }
    
    mutating func emailIsLoading(){
        self.emailLoading = true
    }
    
    mutating func emailLoaded(){
        self.emailLoading = false
    }
    
    mutating func resetInput(){
        self.email = String()
        self.password = String()
        self.emailIsValid = false
        self.passwordIsValid = false
        self.passwordHasEnoughChars = false
        self.passwordHasUpperAndLower = false
        self.passwordHasNumber = false
        self.passwordHasValidOptionalSpecialChars = false
        self.emailLoading = false
        
    }
}

