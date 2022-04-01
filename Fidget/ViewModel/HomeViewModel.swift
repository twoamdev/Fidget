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
    
    
   

    private var db = Firestore.firestore()
    private var auth = Auth.auth()
    private var budgetListener : ListenerRegistration?
    private var bucketNames : [String : String] = [:]
    
    func purgeData(){
        self.userHasBudget = false
        self.budget = Budget()
        self.bucketSearchResults = []
        self.dataLoadedAfterSignIn = false
        self.userProfile = User()
        self.bucketNames = [:]
        self.removeBudgetListener()
        self.invitations = []
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
    
    func removeTransactionFromBudget(_ offsets : IndexSet, _ bucketId : String){
        if offsets.count == 1 {
            let reversedIndex : Int = offsets[offsets.startIndex]
            let count = self.budget.transactions[bucketId]?.count ?? .zero
            if count != .zero{
                let index = (count-1) - reversedIndex
                self.budget.transactions[bucketId]?.remove(at: index)
                updateExistingBudget(self.budget)
            }
            
        }
    }
    
    func renewBudget(){
        
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
        
        //Now that rollover is calculated, empty transactions
        renewBudget.emptyTransactions()
        updateExistingBudget(renewBudget)
    }
    
    
    private func updateExistingBudget(_ budget : Budget){
            do{
                
                let refId = self.userProfile.privateInfo.budgetLinker.getSelectedRefId()
                try self.db.collection(DBCollectionLabels.budgets).document(refId).setData(from: budget)
                self.budget = budget
                
                
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
                updatedUserPrivateData.budgetLinker.selectedIdIndex = updatedUserPrivateData.budgetLinker.referenceIds.count - 1
                try self.db.collection(DBCollectionLabels.users).document(uid).setData(from: updatedUserPrivateData)
                self.loadUserProfileAndBudget()
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
                    try await self.addBudgetListener(self.userProfile.privateInfo.budgetLinker.getSelectedRefId(), completion: { (loadedBudget) in
                        self.budget = loadedBudget
                        self.bucketNames = BudgetDataUtils().loadBucketNames(self.budget.buckets)
                        self.userHasBudget = true
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
    
    
}
