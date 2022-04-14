//
//  BucketsViewModel.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/5/22.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

class HomeViewModel : ObservableObject {
    
    @Published var userHasBudget : Bool = false
    @Published var budget : Budget = Budget()
    @Published var bucketSearchResults : [String] = []
    @Published var dataLoadedAfterSignIn : Bool = false
    @Published var userProfile : User = User()
    @Published var invitations : [Invitation] = []
    @Published var otherUserBudgets : [Budget] = []
    
    @Published var swapBudgetLoading = false

    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    private var budgetListener : ListenerRegistration?
    private var bucketNames : [String : String] = [:]
    
    func purgeData(){
        self.purgeBudgetData()
        self.dataLoadedAfterSignIn = false
        self.userProfile = User()
        self.invitations = []
        self.otherUserBudgets = []
        self.swapBudgetLoading = false
    }
    
    func purgeBudgetData(){
        self.removeBudgetListener()
        self.userHasBudget = false
        self.budget = Budget()
        self.bucketSearchResults = []
        self.bucketNames = [:]
    }
    

    func refreshInvitations(){
        let myUsername = self.userProfile.sharedInfo.username
        print("username on refresh: \(myUsername)")
        if !myUsername.isEmpty{
            FirebaseUtils().fetchBudgetInvitations(completion: { invites in
                self.invitations = invites
                print("received invitations: \(self.invitations)")
            })
        }
    }
    
    func refreshOtherBudgets(){
       Task{
           do{
               print(" --- try await ---")
               try await updateOtherBudgetData(completion: { result in
                   if result {
                       print(" --- done with try await ---")
                       //manageBudgetsVM.initializeOtherBudgetSelections(self.otherUserBudgets.count)
                       print(" --- done with initialized section ---")
                       self.swapBudgetLoading = false
                   }
               })
               
           }
           catch{
               print("error with private updateOtherBudgetData function \(error)")
           }
       }
    }
    
    @MainActor private func updateOtherBudgetData( completion: @escaping (Bool) -> Void) async throws {
        var budgetIds = self.userProfile.privateInfo.budgetLinker.referenceIds
        self.otherUserBudgets = []
        if budgetIds.count > 1 {
            budgetIds.remove(at: .zero)
           
            //now the rest of the reference ids will be the "other budgets"
            for id in budgetIds {
                try await FirebaseUtils().fetchBudgetNonAsync(id, completion: { fetchedBudget in
                    if let fetchedBudget = fetchedBudget{
                        self.otherUserBudgets.append(fetchedBudget)
                    }
                })
            }
            completion(true)
        }
        completion(true)
    }
    
    func acceptInvitation(_ invitation : Invitation){
        self.updateInvitesAndBudget(invitation)
    }
    
    func declineInvitation(_ invitation : Invitation){
        self.updateInvitesOnly(invitation)
    }
    
    private func updateInvitesAndBudget(_ invitation : Invitation){
        self.updateInvites(invitation, updateBudget : true)
    }
    
    private func updateInvitesOnly(_ invitation : Invitation){
        self.updateInvites(invitation, updateBudget : false)
    }
    
    private func updateInvites(_ invitation : Invitation, updateBudget : Bool){
        var updatedInvites : [Invitation] = []
        for invite in self.invitations{
            let budgetRefMatch = invite.getBudgetReferenceID() == invitation.getBudgetReferenceID()
            if !budgetRefMatch{
                updatedInvites.append(invite)
            }
        }
        
        FirebaseUtils().replaceBudgetInvitations(updatedInvites, completion: { result in
            if result{
                self.invitations = updatedInvites
                if updateBudget {
                    self.updateUserBudgetLinker(invitation.getBudgetReferenceID())
                    self.updateAcceptedBudget(invitation.getBudgetReferenceID())
                }
            }
        })
    }
    
    
    
    private func updateUserBudgetLinker(_ budgetReferenceId : String){
        var updatedPrivateInfo = self.userProfile.privateInfo
        updatedPrivateInfo.budgetLinker.referenceIds.append(budgetReferenceId)
        FirebaseUtils().updateUserPrivateInfo(updatedPrivateInfo, completion: { result in
            if result {
                self.userProfile.privateInfo = updatedPrivateInfo
            }
        })
    }
    
    private func updateAcceptedBudget(_ budgetReferenceId : String){
        FirebaseUtils().fetchBudget(budgetReferenceId, completion: { fetchedBudget in
            if var fetchedBudget = fetchedBudget {
                fetchedBudget.linkedUserIds.append(FirebaseUtils().getCurrentUid())
                FirebaseUtils().updateBudget(fetchedBudget, budgetReferenceId, completion: { result in
                    if result {
                        print("accepted budget updated successfully")
                        //now update data with the budget
                        if !self.userHasBudget {
                            print("installed the accepted budget")
                            self.installBudget(fetchedBudget)
                        }
                    }
                })
            }
        })
    }

    func changeFirstAndLastName(_ firstName : String, _ lastName : String){
        if userProfile.sharedInfo.firstName != firstName || userProfile.sharedInfo.lastName != lastName{
            
            var updatedProfile = self.userProfile
            let currentUsername = self.userProfile.sharedInfo.username
            updatedProfile.sharedInfo = User.SharedData(firstName, lastName, currentUsername)
            
            FirebaseUtils().updateUserSharedInfo(FirebaseUtils().getCurrentUid() ,updatedProfile.sharedInfo, completion: { result in
                if result {
                    self.userProfile = updatedProfile
                    print("completed updating Shared Data")
                }
            })
            
            
            
        }
    }
    
    func changeUsername(_ username : String){
        var updatedProfile = self.userProfile
        let currentFirstName = self.userProfile.sharedInfo.firstName
        let currentLastName = self.userProfile.sharedInfo.lastName
        let currentUsername = self.userProfile.sharedInfo.username
        updatedProfile.sharedInfo = User.SharedData(currentFirstName, currentLastName, username)
        
        FirebaseUtils().updateUserSharedInfo(FirebaseUtils().getCurrentUid() ,updatedProfile.sharedInfo, completion: { result in
            if result {
                self.userProfile = updatedProfile
                print("completed updating username Shared Data")
            }
        })
        
        
        FirebaseUtils().updatePublicUsernames(username, currentUsername, completion: { result in
            if result {
                print("update public usernames succcess")
            }
            else{
                print("update public usernames failed")
            }
        })
        
        
    }
    
    func getUserBudgetIdReferences() -> [String] {
        return self.userProfile.privateInfo.budgetLinker.referenceIds
    }
    
    func transactionOwnerName(_ ownerId : String) -> String{
        return ""
    }
    
    func bucketNameSearch(_ input : String){
        let keys = self.bucketNames.keys
        var results : [String] = []
        for myKey in keys {
            let name = myKey.lowercased()
            let myInput = input.lowercased()
            if name.contains(myInput) {
                if results.count < 3{
                    results.append(myKey)
                }
            }
        }
        self.bucketSearchResults = results
    }
    
    func getBudgetIncomeAmount(_ budget : Budget) -> String{
        var amount = 0.0
        for income in budget.incomes {
            amount += income.amount
        }
        return FormatUtils.encodeToNumberLegibleFormat(String(amount), killDecimal: true)
    }
    
    func budgetBalance() -> (Double, Double, Int){
        
        var totalBalance : Double = .zero
        for bucket in self.budget.buckets{
            let id = bucket.id
            totalBalance += bucketBalance(id)
        }
        
        var totalIncome : Double = .zero
        for income in self.budget.incomes{
            totalIncome += income.amount
        }
        
        let percent =  totalIncome == .zero ? .zero : Int( ((totalBalance / totalIncome) * 100.0) )
        
        if totalBalance > totalIncome {
            totalBalance = totalIncome
        }
        
        if totalBalance == .zero && totalIncome == .zero{
            totalIncome = 100.0
        }

        return (totalBalance, totalIncome, percent)
    }
    
    func bucketBalance(_ bucketId : String) -> Double {
        var balance = 0.0
        let transactions = self.budget.transactions[bucketId] ?? []
        for trans in transactions{
            balance += trans.amount
        }
        return balance
    }

    func addBucketToBudget(_ bucket : Bucket){
        self.budget.buckets.append(bucket)
        updateExistingBudget(self.budget)
    }
    
    func updateExistingBucketInBudget(_ updatedBucket : Bucket){
        let bucketCount = self.budget.buckets.count
        for i in 0..<bucketCount{
            if self.budget.buckets[i].id == updatedBucket.id {
                self.budget.buckets[i] = updatedBucket
            }
        }
        updateExistingBudget(self.budget)
    }
    
    func addBucketWithTransactionToBudget(_ bucket : Bucket, _ transaction : Transaction){
        self.budget.buckets.append(bucket)
        self.budget.mapTransactions([transaction])
        updateExistingBudget(self.budget)
    }
    
    func loadRecentTransactions() -> [Transaction]{
        
        var myTransactions : [Transaction] = []
        for pair in self.budget.transactions{
            let transactions = pair.value
            myTransactions += transactions
        }
        
        let budgetDataUtils = BudgetDataUtils()
        myTransactions = budgetDataUtils.sortTransactionsFromNewestToOldest(myTransactions)
        return myTransactions
    }
    
    func transactionsInBucket(_ bucketId : String) -> [Transaction]{
        return self.budget.transactions[bucketId] ?? []
    }
    
    func transanctionBucketName(_ transaction : Transaction) -> String{
        for bucket in self.budget.buckets{
            if bucket.id == transaction.bucketId{
                return bucket.name
            }
        }
        return "--name not found"
    }
    
    func addTransaction(_ bucketName : String, _ amount : Double){
        if amount != .zero{
            if let uid = self.auth.currentUser?.uid{
                let bucketId = bucketNames[bucketName]
                let transaction = Transaction(uid, bucketId ?? "", "", amount, "")
                self.budget.mapTransactions([transaction])
                updateExistingBudget(self.budget)
            }
        }
    }
    
    
    func removeBucketFromBudget(_ offsets : IndexSet){
        if offsets.count == 1 {
            let index : Int = offsets[offsets.startIndex]
            var editedBudget : Budget = self.budget
            let bucketId = editedBudget.buckets[index].id
            editedBudget.buckets.remove(atOffsets: offsets)
            editedBudget.transactions.removeValue(forKey: bucketId)
            updateExistingBudget(editedBudget)
        }
    }
    
    func removeTransactionsFromBudget(_ transactionIds : [String], _ bucketId : String){
        if let transactions = self.budget.transactions[bucketId] {

            var newTransactions : [Transaction] = []
            for i in 0..<transactions.count {
                let myId = transactions[i].id
                if !transactionIds.contains(myId) {
                    newTransactions.append(transactions[i])
                }
            }
            
            if newTransactions.isEmpty{
                //kill the ref in the dictionary
                self.budget.transactions.removeValue(forKey: bucketId)
            }
            else{
                self.budget.transactions[bucketId] = newTransactions
            }
            
            self.updateExistingBudget(self.budget)
        }
    }
    
    func saveChangesToBudget(_ budgetName : String, _ incomeItems : [Budget.IncomeItem], _ isOtherBudget : (Bool , Int)){
        if isOtherBudget.0 {
            let linkerIndex : Int = isOtherBudget.1 + 1
            let budgetRefId = self.userProfile.privateInfo.budgetLinker.referenceIds[linkerIndex]
            var budgetToEdit = self.otherUserBudgets[isOtherBudget.1]
            
            budgetToEdit.name = budgetName
            budgetToEdit.incomes = incomeItems
            
            self.updateExistingBudget(budgetToEdit, budgetReferenceId: budgetRefId)
            self.refreshOtherBudgets()
        }
        else{
            // is current budget
            var copyBudget = self.budget
            copyBudget.name = budgetName
            copyBudget.incomes = incomeItems
            
            self.updateExistingBudget(copyBudget)
            self.swapBudgetLoading = false
        }
    }
    
    func renewBudget(){
        print("APP RENEW BUDGET FOR THE MONTH CHECK")
        
        let lastArchiveInSeconds = self.budget.getLastArchiveInSeconds()
        
        //determine the month and the year
        let budgetArchiveTime = BudgetDataUtils().getYearAndMonthFromTimeInSecondsSince1970(lastArchiveInSeconds)
        let currentTime = BudgetDataUtils().getYearAndMonthFromTimeInSecondsSince1970(Date().timeIntervalSince1970)
        
        if !(budgetArchiveTime.year == currentTime.year && budgetArchiveTime.month == currentTime.month) && self.userHasBudget{

            print("TIME ISN'T equal, need to update")
            let oldBudget = self.budget
            var renewBudget = self.budget
            let budgetDataUtils = BudgetDataUtils()
            
            let bucketCount = renewBudget.buckets.count
            for i in 0..<bucketCount {
                if renewBudget.buckets[i].rolloverEnabled{
                    let key = renewBudget.buckets[i].id
                    let transactions = renewBudget.transactions[key] ?? []
                    let rolloverAmt = renewBudget.buckets[i].capacity - budgetDataUtils.calculateBalance(transactions, key)
                    renewBudget.buckets[i].rolloverCapacity += rolloverAmt
                }
                else{
                    renewBudget.buckets[i].rolloverCapacity = 0.0
                }
            }
            
            
            
            //archive old budget
            let budgetRefId = self.userProfile.privateInfo.budgetLinker.getSelectedRefId()
            let archiveDateString = BudgetDataUtils().getPreviousMonth(year: currentTime.year , month: currentTime.month)
            FirebaseUtils().archiveBudget(oldBudget, budgetRefId, archiveDateString, completion: { result in
                if result {
                    print("succesful ARCHIVE")
                    //Now that archive succeeded, lets refresh the current budget data
                    renewBudget.emptyTransactions()
                    renewBudget.setArchiveDateToNow()
                    self.updateExistingBudget(renewBudget)
                }
            })
            
        }
        else{
            print("no need to update")
        }
        
    }
    
    
    private func updateExistingBudget(_ budget : Budget, budgetReferenceId : String = ""){
            do{
                let refId =  budgetReferenceId.isEmpty ? self.userProfile.privateInfo.budgetLinker.getSelectedRefId() : budgetReferenceId
                try self.db.collection(DBCollectionLabels.budgets).document(refId).setData(from: budget)
                if budgetReferenceId.isEmpty {
                    self.budget = budget
                }
            }
            catch{
                print(error)
            }
    }
    
    func saveNewBudget(_ budgetName : String, _ buckets : [Bucket], _ incomeItems : [Budget.IncomeItem], _ transactions : [Transaction]) {
        do{
            if let uid = auth.currentUser?.uid{
                let budget = Budget(budgetName, buckets, incomeItems, transactions, [uid])
                let doc = try self.db.collection(DBCollectionLabels.budgets).addDocument(from: budget)
             
                var updatedUserPrivateData = self.userProfile.privateInfo
                updatedUserPrivateData.budgetLinker.referenceIds.append(doc.documentID)
                //updatedUserPrivateData.budgetLinker.selectedIdIndex = updatedUserPrivateData.budgetLinker.referenceIds.count - 1
                try self.db.collection(DBCollectionLabels.users).document(uid).setData(from: updatedUserPrivateData)
                
                if !self.userHasBudget {
                    self.loadUserProfileAndBudget()
                }
                else{
                    self.userProfile.privateInfo = updatedUserPrivateData
                }
            }
        }
        catch{
            print(error)
        }
    }
        
    func loadUserProfileAndBudget(loadingAfterUserSignIn : Bool = false){
        if loadingAfterUserSignIn {
            self.dataLoadedAfterSignIn = false
        }
        Task{
            do{
                print("Going to fetch private data")
                try await self.fetchUserPrivateData()
                print("Going to fetch shared data")
                try await self.fetchUserSharedData()
                print("done fetching")
                
                let userHasBudget = !self.userProfile.privateInfo.budgetLinker.referenceIds.isEmpty
                if userHasBudget {
                    try await self.addBudgetListener(self.userProfile.privateInfo.budgetLinker.getSelectedRefId(),
                        completion: { (loadedBudget) in
                        self.installBudget(loadedBudget)
                    })
                }
                
                if loadingAfterUserSignIn {
                    let waitTime = 0.0
                    Timer.scheduledTimer(withTimeInterval: waitTime, repeats: true) { timer in
                        self.dataLoadedAfterSignIn = true
                        timer.invalidate()
                    }
                }
            }
            catch{
                print(error)
            }
        }
         
    }
    
    private func installBudget(_ budget : Budget){
        self.budget = budget
        self.bucketNames = BudgetDataUtils().loadBucketNames(self.budget.buckets)
        self.userHasBudget = true
    }
    
    @MainActor private func fetchUserPrivateData() async throws{
        if let uid = self.auth.currentUser?.uid{
            try await FirebaseUtils().fetchUserPrivateData(uid){ (data) in
                if data != nil{
                    let privateData : User.PrivateData = data!
                    self.userProfile.privateInfo = privateData
                }
            }
        }
    }
    
    @MainActor private func fetchUserSharedData() async throws{
        if let uid = self.auth.currentUser?.uid{
            try await FirebaseUtils().fetchUserSharedData(uid){ (data) in
                if data != nil{
                    let sharedData : User.SharedData = data!
                    self.userProfile.sharedInfo = sharedData
                    print("got shared data: \(self.userProfile.sharedInfo)")
                }
            }
        }
    }
    
    @MainActor private func addBudgetListener(_ referenceId : String, completion: @escaping (Budget) -> Void) async throws {
        self.removeBudgetListener()
        self.budgetListener = self.db.collection(DBCollectionLabels.budgets).document(referenceId).addSnapshotListener{ (snapshot, error) in
            if let mybudget = try? snapshot?.data(as: Budget.self){
                completion(mybudget)
            }
        }
    }
    
    func removeBudgetListener(){
        self.budgetListener?.remove()
    }
    
    func detachFromBudget(deleteBudget : Bool = false, unfollowBudget : Bool = false, isCurrentBudget : Bool = false, otherBudgetIndex : Int = -1){
        let validIndex = (otherBudgetIndex < self.otherUserBudgets.count && otherBudgetIndex >= 0) ? true : false
        
        if deleteBudget{
            if isCurrentBudget{
                print("\n====\nDELETE CURRENT BUDGET\n====")
                self.deleteCurrentBudget()
            }
            else if validIndex{
                print("\n====\nDELETE OTHER BUDGET\n====")
                self.deleteOtherBudget(otherBudgetIndex)
            }
        }
        else if unfollowBudget{
            if isCurrentBudget{
                print("\n====\nUNFOLLOW CURRENT BUDGET\n====")
                self.unfollowCurrentBudget()
            }
            else if validIndex{
                print("\n====\nUNFOLLOW OTHER BUDGET\n====")
                print("other budget index: \(otherBudgetIndex)")
                self.unfollowOtherBudget(otherBudgetIndex)
               
            }
        }
    }
    
    private func deleteCurrentBudget(){
        //delete current budget
        let budgetReferenceId = self.userProfile.privateInfo.budgetLinker.getSelectedRefId()
        FirebaseUtils().deleteBudget(budgetReferenceId, completion: { result in
            if result {
                self.updateBudgetLinkerAndInstallNextBudget()
            }
        })
    }
    
    private func updateBudgetLinkerAndInstallNextBudget(){
        //update budget linker
        print("updateBudgetLinkerAndInstallNextBudget enter ---")
        let index = self.userProfile.privateInfo.budgetLinker.selectedIdIndex
        self.userProfile.privateInfo.budgetLinker.referenceIds.remove(at: index)
        self.userProfile.privateInfo.budgetLinker.selectedIdIndex = .zero
        FirebaseUtils().updateUserPrivateInfo(self.userProfile.privateInfo, completion: { _ in
            print("updated user profile successfully")
            print("purging current Budget data")
            self.purgeBudgetData()
            print("installNextInLineBudgetIfExists enter ---")
            self.installNextInLineBudgetIfExists()
        })
    }
    
    private func installNextInLineBudgetIfExists(){
        //if the user has other budgets, then set the next one in line to be the current budget
        let potentialBudgetRefId = self.userProfile.privateInfo.budgetLinker.getSelectedRefId()
        if !potentialBudgetRefId.isEmpty{
            FirebaseUtils().fetchBudget(potentialBudgetRefId, completion: { newBudget in
                if let newBudget = newBudget {
                    print("new budget installed")
                    self.installBudget(newBudget)
                    self.refreshOtherBudgets()
                }
            })
        }
        else{
            self.refreshOtherBudgets()
        }
        self.swapBudgetLoading = false
    }
    
    private func unfollowCurrentBudget(){
        self.eraseCurrentUserIdFromBudgetAndUpdateBudgetInFirestore(self.budget)
        
        //update personal info by erasing budget reference from personal info, and then install next budget if possible
        self.updateBudgetLinkerAndInstallNextBudget()
    }
    
    private func eraseCurrentUserIdFromBudgetAndUpdateBudgetInFirestore(_ givenBudget : Budget, refId : String = ""){
        //update the budget by erasing self from linked users
        var inBudget = givenBudget
        print("in Budget : \(inBudget)\n---\n")
        let myUserId = FirebaseUtils().getCurrentUid()
        var updatedLinkedUsers : [String] = []
        
        for userId in inBudget.linkedUserIds{
            if userId != myUserId{
                updatedLinkedUsers.append(userId)
            }
        }
        inBudget.linkedUserIds = updatedLinkedUsers
        print(" in budget updated linked users ids: \(inBudget.linkedUserIds)")
        self.updateExistingBudget(inBudget, budgetReferenceId: refId)
    }
    
    
    private func deleteOtherBudget(_ otherBudgetIndex : Int){
        //delete other budget at given index
        let linkerIndex = otherBudgetIndex + 1
        let budgetRefId = self.userProfile.privateInfo.budgetLinker.referenceIds[linkerIndex]
        FirebaseUtils().deleteBudget(budgetRefId, completion: { result in
            if result {
                self.userProfile.privateInfo.budgetLinker.referenceIds.remove(at: linkerIndex)
                FirebaseUtils().updateUserPrivateInfo(self.userProfile.privateInfo, completion: { _ in
                    print("other private budget deleted")
                    self.refreshOtherBudgets()
                    self.swapBudgetLoading = false
                })
            }
        })
    }
    
    private func unfollowOtherBudget(_ otherBudgetIndex : Int){
        let selectedOtherBudget = self.otherUserBudgets[otherBudgetIndex]
        let linkerBudgetIndex = otherBudgetIndex + 1
        let budgetRefId = self.userProfile.privateInfo.budgetLinker.referenceIds[linkerBudgetIndex]

        self.eraseCurrentUserIdFromBudgetAndUpdateBudgetInFirestore(selectedOtherBudget , refId: budgetRefId)

        self.userProfile.privateInfo.budgetLinker.referenceIds.remove(at: linkerBudgetIndex)
  
        FirebaseUtils().updateUserPrivateInfo(self.userProfile.privateInfo, completion: { _ in
            self.otherUserBudgets.remove(at: otherBudgetIndex)
            self.swapBudgetLoading = false
        })
    }
    
    func setToCurrentBudget(_ otherBudgetIndex : Int, _ budgetRefId : String){
        let inRange = otherBudgetIndex >= 0 && otherBudgetIndex <= (self.otherUserBudgets.count - 1)
        print("count of other budgets: \(self.otherUserBudgets.count)")
        if inRange{
            print("in range")
            let budgetToSet = self.otherUserBudgets[otherBudgetIndex]
            
            print("budget to set: \(budgetToSet.name)")
            
            //update personal info
            var newRefIdsList : [String] = []
            for refId in self.userProfile.privateInfo.budgetLinker.referenceIds {
                if refId != budgetRefId {
                    newRefIdsList.append(refId)
                }
            }
            // now add the budget ref id to the top of the list
            newRefIdsList.insert(budgetRefId, at: .zero)
            print("updated refids: \(newRefIdsList)")
            
            var updatedPrivateData = self.userProfile.privateInfo
            updatedPrivateData.budgetLinker.referenceIds = newRefIdsList
            FirebaseUtils().updateUserPrivateInfo(updatedPrivateData, completion: { result in
                if result{
                    print("success update")
                    self.userProfile.privateInfo = updatedPrivateData
                    //now update the budget locally, since no firebase update required
                    self.purgeBudgetData()
                    self.installBudget(budgetToSet)
                    
                    self.refreshOtherBudgets()
                    
                    print("refreshed after installing other budget as current budget")
                }
            })
        }
        
    }
}
