//
//  ShareBudgetViewModel.swift
//  Fidget
//
//  Created by Ben Nelson on 3/29/22.
//

import SwiftUI

class ShareBudgetViewModel: ObservableObject {
    
    @Published var usernameIsValid = false
    @Published var usernameLengthIsValid = false
    @Published var usernameCharsAreValid = false
    @Published var showAlert = false
    @Published var usernameSuccess = false
    @Published var alertText = String()
    @Published var alertMessage = String()

    @MainActor func validateUsername(_ username : String, _ currentUsersUsername : String, _ budgetReferenceId : String){
       
        if username == currentUsersUsername {
            let message = "You don't need to share a budget with yourself."
            self.setAlert(false, message)
        }
        else{
            ValidationUtils().validateUsername(username, completion: { usernameCheckBundle in
                self.usernameIsValid = usernameCheckBundle.usernameIsValid
                self.usernameLengthIsValid = usernameCheckBundle.lengthIsValid
                self.usernameCharsAreValid = usernameCheckBundle.charsAreValid
                
                let success = !self.usernameIsValid && self.usernameLengthIsValid && self.usernameCharsAreValid
                if success {
                    FirebaseUtils().fetchUidFromUsername(username, completion: { uid in
                        if uid.isEmpty {
                            let failMessage = "There was an issue finding that person. It could be an internet connection issue, so you'll have to try again later."
                            self.setAlert(false, failMessage)
                        }
                        else{
                            // send off invite to user
                            FirebaseUtils().sendBudgetInvitation(toUid: uid, fromUsername: currentUsersUsername, budgetRefId: budgetReferenceId, completion: { result in
                                let failMessage = "There was an issue sending your invite. It could be an internet connection issue, so you'll have to try again later."
                                let message = result ? "@\(username) should have your invite now." : failMessage
                                self.setAlert(result, message)
                            })
                        }
                        
                    })
                }
                else{
                    let failMessage = "There is no person registered with the username you listed."
                    self.setAlert(false, failMessage)
                }
                
            })
        }
    }
    
    private func setAlert(_ wasSendSuccessful : Bool, _ message : String){
        self.alertText = wasSendSuccessful ? "Budget sent." : "No budget was sent."
        self.alertMessage = message
        self.usernameSuccess = wasSendSuccessful
        self.showAlert = true
    }
}
