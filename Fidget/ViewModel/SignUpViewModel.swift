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
    private var homeVM : HomeViewModel?
    
    @Published var userInput = SignUpUserInput()
    @Published var userSignUpStatus = SignUpStatus()
    @Published var showHome : Bool = false
 

    
    @MainActor func validateEmailAddress(_ email : String){
        ValidationUtils().validateEmailAddress(email, self)
    }
    
    @MainActor func validatePassword(_ password : String){
        self.userInput.passwordIsValid = ValidationUtils().validatePassword(password, self)
    }
    
    
    func signUpUser(showOnboarding : Binding<Bool>, _ homeViewModel : HomeViewModel) {
        self.homeVM = homeViewModel
        if self.userInput.allAreValid() {
            self.createUserAccount(showOnboarding)
        }
    }
    
    //MEANT FOR DEBUG PURPOSES ONLY
    /*
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
    }*/
    
    private func createUserAccount(_ showOnboarding : Binding<Bool>){
        
        let email = self.userInput.email.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = self.userInput.password
        let userProfile = User(String(), String(), String() , email)

        self.auth.createUser(withEmail: email, password: password, completion: { (result, err) in
            if err == nil{
                self.userSignUpStatus.userCreatedStatus(true)
                
                if let uid = result?.user.uid{
                    self.userInput.resetInput()
                    self.setPrivateUserData(uid, userProfile, showOnboarding)              // <- Whichever finishes last triggers showHome
                    self.setPublicData(email: email, username: String(), showOnboarding)   // <- Whichever finishes last triggers showHome
                }
            }
            else{
                self.userSignUpStatus.resetStatus()
                if let codeValue = err?._code {
                    let code = AuthErrorCode(rawValue: codeValue)
                    if code == AuthErrorCode.emailAlreadyInUse{
                        self.userInput.emailIsValid = false
                    }
                }
                print(err ?? "error on user creation")
            }
        })
    }
    
    private func setPrivateUserData(_ uid : String, _ userProfile : User, _ showOnboarding : Binding<Bool>) {
        do{
            try self.db.collection(DBCollectionLabels.users).document(uid).setData(from: userProfile.privateInfo)
            self.userSignUpStatus.storePrivateUserDataStatus(true)
            self.attemptToClearOnboarding(showOnboarding)
        }
        catch{
            self.userSignUpStatus.storePrivateUserDataStatus(false)
            print(error)
        }
    }
    
    
    /*
    private func setSharedUserData(_ uid : String, _ userProfile : User) {
        do{
            try self.db.collection(DbCollectionA.sharedData).document(uid).setData(from: userProfile.sharedInfo)
            self.userSignUpStatus.storeSharedUserDataStatus(true)
            self.isProcessingSignUp = !userSignUpStatus.success()
        }
        catch{
            self.userSignUpStatus.storeSharedUserDataStatus(false)
            print(error)
        }
    }*/
    
    private func setPublicData(email : String, username : String,  _ showOnboarding : Binding<Bool>) {
        self.db.collection(DBCollectionLabels.publicEmails).document(email).setData([:])
        self.userSignUpStatus.storePublicDataStatus(true)
        self.attemptToClearOnboarding(showOnboarding)
    }
    
    private func attemptToClearOnboarding(_ showOnboarding : Binding<Bool>){
        showOnboarding.wrappedValue = !userSignUpStatus.success()
        self.showHome = userSignUpStatus.success()

        if self.showHome {
            self.userSignUpStatus.resetStatus()
            self.homeVM?.loadUserProfileAndBudget(loadingAfterUserSignIn: true)
            print("SET DATA PROPERLY")
        }
    }
    
    /*
    private func showLoadAnimation(){
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
     */
}

struct SignUpStatus{
    private var createdUserSuccess = false
    private var storedUserPrivateInfoSuccess = false
    private var storedPublicDataSuccess = false
     
    func success() -> Bool {

        return self.createdUserSuccess && self.storedUserPrivateInfoSuccess && self.storedPublicDataSuccess
    }
    
    mutating func userCreatedStatus(_ status : Bool){
        self.createdUserSuccess = status
    }
    
    mutating func storePrivateUserDataStatus(_ status : Bool){
        self.storedUserPrivateInfoSuccess = status
    }
    
    mutating func storePublicDataStatus(_ status : Bool){
        self.storedPublicDataSuccess = status
    }
    
    mutating func resetStatus(){
        self.createdUserSuccess = false
        self.storedUserPrivateInfoSuccess = false
        self.storedPublicDataSuccess = false
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

