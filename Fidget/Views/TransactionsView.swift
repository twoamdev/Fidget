//
//  AllocateView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI
import Introspect

struct TransactionsView: View {
    @EnvironmentObject var homeViewModel : HomeViewModel
    @EnvironmentObject var transactionViewModel : TransactionViewModel
    @State private var showAddTransaction = false
    @State private var showAddTransactionAmount = false
    @State private var currentBucketName = String()
    @State private var rawBucketName = String()
    
    @State private var amountString = String()
    @State private var prevAmountString  = String()
    @State private var transactionAmount : Double = 0.0
    
    @State private var showAddTransactionAlert = false
    
    enum FocusField: Hashable {
        case field
    }
    
    @FocusState private var focusedField: FocusField?
    
    
    
    
    func resetInput(){
        amountString = String()
        prevAmountString = String()
        transactionAmount = 0.0
    }
    
    var body: some View {
        ZStack{
            
            listTransactions
                .blur(radius: showAddTransaction ? 8 : 0)
                .disabled(showAddTransaction)
            
            ZStack{
                VStack{
                    topBanner
                    Spacer()
                }
                .blur(radius: showAddTransaction ? 4 : 0)
                VStack{
                    Spacer()
                    VStack(spacing: 0){
                        Divider()
                            .background(AppColor.normal)
                        addTransaction
                    }
                }
            }
        }
    }
    
    var listTransactions : some View {
        VStack{
            let transactions = homeViewModel.loadRecentTransactions()
            let count = transactions.count > 25 ? 25 : transactions.count
            if count == .zero {
                Text("No Transactions Yet.")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.inputFieldSize))
            }
            else{
                VStack(){
                    List{
                        
                        Rectangle()
                            .frame(width: 60, height: 125)
                            .opacity(0)
                            .listRowSeparator(.hidden)
                        
                        ForEach(0..<count , id: \.self) { i in
                            let trans = transactions[i]
                            let bucketName = homeViewModel.transanctionBucketName(trans)
                            let displayOwnerName = transactionViewModel.transactionOwnerDisplayName(trans)
                            TransactionListElementView(transaction: trans, bucketName: bucketName, ownerDisplayName: displayOwnerName)
                        }
                    }
                    .listStyle(.plain)
                    .clipped()
                }
            }
        }
    }
    
    var topBanner : some View {
        MiniBudgetView()
    }
    
    var addTransaction : some View {
        VStack{
            
            if showAddTransaction {
                
                VStack(spacing: 0){
                    HStack{
                        Text(showAddTransactionAmount ? "Enter amount" : "Choose a bucket")
                            .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                            .kerning(AppFonts.titleKerning)
                            .foregroundColor(AppColor.fg)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    if !showAddTransactionAmount {
                        //SCROLL  ------
                        let buckets = homeViewModel.budget.buckets
                        let range = 0...(buckets.count-1)
                        
                        let gridItem = GridItem(.fixed(30))
                        let rows = [
                            gridItem, gridItem, gridItem, gridItem
                        ]
                        
                        
                        ScrollView(.horizontal , showsIndicators: false) {
                            LazyHGrid(rows: rows, alignment: .center , spacing: 10) {
                                ForEach(range, id: \.self) { i in
                                    let labelName = buckets[i].name.uppercased()
                                    let rawName = buckets[i].name
                                    StandardButton(label: labelName, function: {
                                        showAddTransactionAmount.toggle()
                                        currentBucketName = labelName
                                        rawBucketName = rawName
                                        UXUtils.hapticButtonPress()
                                        
                                    }).primaryButtonShrinkWrap
                                        .padding(.horizontal)
                                }
                            }
                            .frame(height : 175)
                        }
                        //END OF SCROLL -----
                    }
                    else{
                        VStack{
                            HStack {
                                StandardButton(label: currentBucketName).primaryLabelShrinkWrap
                                Spacer()
                            }
                            .padding(.horizontal)
                            StandardTextField(label: "Amount", text: $amountString)
                                .padding(.horizontal)
                                .keyboardType(.decimalPad)
                                .onChange(of: amountString, perform: { value in
                                    let helper = NumberFormatterHelper(value, amountString, prevAmountString, transactionAmount)
                                    FormatUtils.formatNumberStringForUserAndValue(helper)
                                    amountString = helper.displayText
                                    prevAmountString = helper.prevDisplayText
                                    transactionAmount = helper.numberValue
                                })
                                .focused($focusedField, equals: .field)
                                .task {
                                    self.focusedField = .field
                                }
                            
                            HStack{
                                StandardButton(label: "BACK", function: {
                                    showAddTransactionAmount.toggle()
                                    resetInput()
                                    
                                }).normalButtonLarge
                                StandardButton(label: "DONE", function: {
                                    UXUtils.hapticButtonPress()
                                    homeViewModel.addTransaction(rawBucketName, transactionAmount)
                                    //print("transation for: \(rawBucketName) -- $\(transactionAmount)")
                                    showAddTransaction.toggle()
                                    showAddTransaction = false
                                    resetInput()
                                }).primaryButtonLarge
                                    .disabled(amountString.isEmpty || transactionAmount == .zero)
                            }
                            .padding(.horizontal)
                        }
                        .frame(height : 175)
                    }
                }
            }
            VStack{

                let shouldLock = homeViewModel.budget.buckets.count == .zero ? true : false
                
                StandardButton(lockedStyle: shouldLock, label: showAddTransaction ? "CANCEL" : "ADD TRANSACTION", function: {
                    if shouldLock {
                        showAddTransactionAlert.toggle()
                    }
                    else{
                        if !showAddTransaction {
                            UXUtils.hapticButtonPress()
                        }
                        showAddTransaction.toggle()
                        showAddTransactionAmount = false
                        resetInput()
                    }
                }).normalButtonLarge
                    .padding(.horizontal)
                    .padding(showAddTransaction ? .bottom : .vertical)
                    .alert(isPresented: $showAddTransactionAlert) {
                        Alert(
                            title: Text("No buckets exist"),
                            message: Text("Once you have created buckets " +
                                          "in your budget, you can add transactions.")
                        )
                    }
                    
            }
        }
        .background(AppColor.bg)
        .clipShape(Rectangle())
        //.shadow(radius: showAddTransaction ? 10 : 0)
    }
    
    
}





/*
 struct AllocateView_Previews: PreviewProvider {
 static var previews: some View {
 TransactionsView()
 }
 }
 */
