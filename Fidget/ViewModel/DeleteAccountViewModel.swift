//
//  DeleteAccountViewModel.swift
//  Fidget
//
//  Created by Ben Nelson on 3/12/22.
//

import Foundation


class DeleteAccountViewModel : ObservableObject{
    
    private var publicEmailDeleted : Bool = false
    private var publicUsernameDeleted : Bool = false
    private var privateUserDataDeleted : Bool = false
    private var sharedUserDataDeleted : Bool = false
    private var budgetIsDeletedOrUpdated : Bool = false
    private var invitationsDeleted : Bool = false
    private var homeVM : HomeViewModel?
    private var transactionVM : TransactionViewModel?
    
    func deleteUserAccount(_ homeViewModel : HomeViewModel, _ transactionViewModel : TransactionViewModel){
        print("HEY STARTING THE DELETE HERE *****_________________\n\n\n\n\n")
        self.homeVM = homeViewModel
        self.transactionVM = transactionViewModel
        
        let userProfile = homeViewModel.userProfile
        let userId = FirebaseUtils().getCurrentUid()
        if userId != FirebaseUtils.noUserFound {
            
            let email = userProfile.privateInfo.emailAddress
            let username = userProfile.sharedInfo.username
            print("purging data")
            self.purgeAppData()
            print("calling DELETE PUBLIC DATA")
            self.deletePublicData(email, username)
            print("calling DELETE INVITES DATA")
            self.deleteInvitationsData(userId)
            print("calling DELETE SHARED DATA")
            self.deleteSharedData(userId)
            print("calling DELETE PRIVATE DATA")
            self.deletePrivateData(userId)
            print("calling DELETE BUDGET DATA")
            self.deleteBudgets(userId, userProfile)
            
        }
    }
    
    private func deleteIsComplete() -> Bool {
        return self.publicEmailDeleted && self.publicUsernameDeleted && self.privateUserDataDeleted && self.budgetIsDeletedOrUpdated && self.sharedUserDataDeleted && self.invitationsDeleted
    }
    
    private func deleteUserOnceAllDataIsDeleted(){
        if self.deleteIsComplete(){
            FirebaseUtils().deleteUser(completion: { result in
                print("USER DELETED FROM FIREBASE -----")
            })
        }
    }
    
    private func purgeAppData(){
        if let homeVM = self.homeVM {
            print("home data purged")
            homeVM.purgeData()
        }
        if let transactionVM = self.transactionVM{
            print("transaction data purged")
            transactionVM.purgeData()
        }
        
    }
    
    private func deletePublicData(_ email : String, _ username : String){
        //print("HERE IS THE USER: \(userProfile)")
        FirebaseUtils().deletePublicEmail(email, completion: { result in
            self.publicEmailDeleted = result
            self.deleteUserOnceAllDataIsDeleted()
            print("\t---Public EMAIL deleted")
        })
        
        if !username.isEmpty {
            FirebaseUtils().deletePublicUsername(username, completion: { result in
                self.publicUsernameDeleted = result
                self.deleteUserOnceAllDataIsDeleted()
                print("\t---Public USERNAME deleted")
            })
        }
        else{
            self.publicUsernameDeleted = true
            self.deleteUserOnceAllDataIsDeleted()
            print("\t---Public USERNAME not found, good to go")
        }
    }
    
    private func deleteInvitationsData(_ userId : String){
        FirebaseUtils().deleteInvitationsData(userId, completion: { result in
            self.invitationsDeleted = result
            self.deleteUserOnceAllDataIsDeleted()
            print("\t---Invite Data deleted")
        })
    }
    
    private func deleteSharedData(_ userId : String){
        FirebaseUtils().deleteSharedUserData(userId, completion: { result in
            self.sharedUserDataDeleted = result
            self.deleteUserOnceAllDataIsDeleted()
            print("\t---Shared User Data deleted")
        })
    }
    
    private func deleteBudgets(_ userId : String, _ user : User){
        let budgetLinker = user.privateInfo.budgetLinker
        let budgetIds = budgetLinker.referenceIds
        
        //No need to do anything else if budget is empty
        if budgetIds.isEmpty {
            self.budgetIsDeletedOrUpdated = true
            self.deleteUserOnceAllDataIsDeleted()
            print("Budget data is not linked to user")
            print("\t---Budget Data successfully taken care of, nothing to remove")
            print("finished all budget requests")
            return
        }
        
        let dispatchGroup = DispatchGroup()
        
        for budgetId in budgetIds{
            dispatchGroup.enter()
            FirebaseUtils().fetchBudget(budgetId, completion: { budget in
                print("\t--- fetching budget completed")
                if let budget = budget{
                    self.checkForSoleOwnerOfBudget(budget, userId, completion: { (updatedBudget, isSoleOwner) in
                        if isSoleOwner {
                            // delete budget
                            FirebaseUtils().deleteBudget(budgetId, completion: { result in
                                self.budgetIsDeletedOrUpdated = result
                                
                                print("\t---is Budget Sole Owner, budget deleted")
                                
                                dispatchGroup.leave()
                            })
                        }
                        else{
                            // update budget
                            if let updatedBudget = updatedBudget {
                                FirebaseUtils().updateBudget(updatedBudget, budgetId, completion: { result in
                                    self.budgetIsDeletedOrUpdated = result
                                    print("\t---is NOT Sole Owner, budget reference deleted")
                                    
                                    dispatchGroup.leave()
                                })
                            }
                        }
                        
                        
                    })
                }
            })
        }
        
        dispatchGroup.notify(queue: .main){
            print("finished all budget requests")
            self.deleteUserOnceAllDataIsDeleted()
        }
        
        
    }
    
    /*
     print("\t--- fetching budget completed")
     if let budget = budget{
     self.checkForSoleOwnerOfBudget(budget, userId, completion: { (updatedBudget, isSoleOwner) in
     if isSoleOwner {
     // delete budget
     FirebaseUtils().deleteBudget(budgetId, completion: { result in
     self.budgetIsDeletedOrUpdated = result
     self.deleteUserOnceAllDataIsDeleted()
     print("\t---is Budget Sole Owner, budget deleted")
     })
     }
     else{
     // update budget
     if let updatedBudget = updatedBudget {
     FirebaseUtils().updateBudget(updatedBudget, budgetId, completion: { result in
     self.budgetIsDeletedOrUpdated = result
     self.deleteUserOnceAllDataIsDeleted()
     print("\t---is NOT Sole Owner, budget reference deleted")
     })
     }
     }
     
     })
     }
     */
    private func deletePrivateData(_ userId : String){
        FirebaseUtils().deletePrivateUserData(userId, completion: { result in
            self.privateUserDataDeleted = result
            self.deleteUserOnceAllDataIsDeleted()
            print("\t---Private User Data deleted")
        })
    }
    
    private func checkForSoleOwnerOfBudget(_ budget : Budget, _ uid : String, completion: @escaping (Budget?, Bool) -> Void){
        var userIds : [String] = []
        for userId in budget.linkedUserIds{
            if userId != uid{
                userIds.append(userId)
            }
        }
        if userIds.isEmpty{
            print("budget user ids was empty, so that means there was a sole owner")
            completion(nil,true)
        }
        else{
            print("budget had more than one linked user")
            print("currrnet linked users: \(budget.linkedUserIds)")
            var updatedBudget = budget
            updatedBudget.linkedUserIds = userIds
            completion(updatedBudget, false)
        }
    }
}
