//
//  PersonalInfoViewModel.swift
//  Fidget
//
//  Created by Ben Nelson on 3/13/22.
//

import SwiftUI

class PersonalInfoViewModel : ObservableObject{
    @Published var inputUsername = String()
    @Published var currentUsername = String()
    @Published var usernameIsValid = false
    @Published var isUsernameLoading = false
    @Published var usernameCharsAreValid = false
    @Published var usernameLengthIsValid = false
    
    @Published var currentFullName = String()
    @Published var inputFirstName = String()
    @Published var inputFirstNameIsValid = false
    
    @Published var inputLastName = String()
    @Published var inputLastNameIsValid = false
    
    
    func usernameIsLoading(){
        self.isUsernameLoading = true
    }
    
    func usernameIsDoneLoading(){
        self.isUsernameLoading = false
    }
    
    @MainActor func validateUsername(_ username : String){
        self.usernameIsLoading()
        self.inputUsername = username
        ValidationUtils().validateUsername(username, completion: { usernameCheckBundle in
            self.usernameIsValid = usernameCheckBundle.usernameIsValid
            self.usernameLengthIsValid = usernameCheckBundle.lengthIsValid
            self.usernameCharsAreValid = usernameCheckBundle.charsAreValid
            self.usernameIsDoneLoading()
        })
    }
    
    @MainActor func validateFirstName(_ name : String){
        self.inputFirstNameIsValid = ValidationUtils().validateName(name)
    }
    
    
    @MainActor func validateLastName(_ name : String){
        self.inputLastNameIsValid = ValidationUtils().validateName(name)
    }
    
    func resetSharedInfoInputs(){
        self.inputUsername = String()
        self.usernameIsValid = false
        self.isUsernameLoading = false
        self.usernameCharsAreValid = false
        self.usernameLengthIsValid = false
        self.inputFirstName = String()
        self.inputFirstNameIsValid = false
        self.inputLastName = String()
        self.inputLastNameIsValid = false
    }
}

