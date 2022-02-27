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
    @State private var userMessage: String = ""
    @State private var userAmount : Double = 0.0
    @State private var moneyAmount: String = ""
    @State private var showSearchResults : Bool = false
    @State private var bucketNameIsEntered : Bool = false
    @State private var userBucketName : String = ""
    
    private var myFormatter = NumberFormatter()
    
    init(){
        self.myFormatter.zeroSymbol = ""
    }
    
    enum Field: Hashable {
        case myField, numberField
    }
    @FocusState private var focusedField: Field?
    @FocusState private var numberFocusField: Field?
    
    
    var body: some View {
        VStack(){

            VStack(){
                let transactions = homeViewModel.loadRecentTransactions()
                let count = transactions.count > 25 ? 25 : transactions.count
                List{
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
            
            
            
            Spacer()
            if showSearchResults{
                
                
                let results = homeViewModel.bucketSearchResults
                ForEach(0..<results.count, id: \.self) { i in
                    let result = results[i]
                    HStack(){
                        Button(action: {
                            userMessage = result
                            userBucketName = result
                            bucketNameIsEntered = true
                            showSearchResults = false
                            focusedField = nil
                            numberFocusField = .numberField
                        },label: {
                            Text(result)
                                .padding(EdgeInsets(top: 5, leading: 8, bottom: 5, trailing: 8))
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(15)
                        })
                            .padding(.horizontal)
                        Spacer()
                    }
                    .transition(.moveInScaleOutLeadingAnchor)
                }
                
            }
            ZStack(){
                
                HStack{
                    
                    TextField("Bucket Name -- Then Amount Spent", text: $userMessage)
                        .font(Font.custom(AppFonts.mainFontRegular,size:15))
                        .foregroundColor(bucketNameIsEntered ? .blue : .black)
                        .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                        .background(.white)
                        .cornerRadius(30)
                        .overlay(RoundedRectangle(cornerRadius: 30)
                                    .stroke(AppColor.primary)
                        )
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
                        .focused($focusedField, equals: .myField)
                        .onChange(of: userMessage, perform: { userInput in
                            withAnimation {
                                if userInput != userBucketName{
                                    bucketNameIsEntered = false
                                    userBucketName = ""
                                }
                                
                                if !bucketNameIsEntered {
                                    if userMessage.isEmpty{
                                        showSearchResults = false
                                    }
                                    else{
                                        
                                        showSearchResults = true
                                        
                                    }
                                    homeViewModel.bucketNameSearch(userInput)
                                }
                            }
                        })
                    
                    
                    
                    
                    Button(
                        action:{
                            if bucketNameIsEntered{
                                homeViewModel.addTransaction(userBucketName, userAmount)
                                bucketNameIsEntered = false
                                userAmount = 0.0
                                userMessage = ""
                                userBucketName = ""
                                numberFocusField = nil
                                focusedField = nil
                            }
                    }
                        ,label: {
                            Image(systemName: "arrow.up.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 10))
                                
                                
                        
                    })
                    
                    
                    
                    Spacer()
                }
                
                
                if bucketNameIsEntered {
                    
                    HStack(){
                        
                        Text(userMessage)
                            .font(Font.custom(AppFonts.mainFontRegular,size:15))
                            .foregroundColor(.white)
                            .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                            .background(.blue)
                            .cornerRadius(30)
                            .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 0))
                        
                        TextField("", value: $userAmount, formatter: myFormatter)
                            .font(Font.custom(AppFonts.mainFontRegular,size:15))
                            .foregroundColor(.red)
                            .padding(EdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10))
                            .background(.red.opacity(0))
                            .cornerRadius(30)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                            .keyboardType(.decimalPad)
                            .focused($numberFocusField, equals: .numberField)
                        
                        //HIDDEN PLACEHOLDER
                        Image(systemName: "arrow.up.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                            .hidden()
                        
                        
                        
                        
                        Spacer()
                    }
                    
                    
                    
                    
                }
            }
            
            
        }
        
    }
}



/*
 struct AllocateView_Previews: PreviewProvider {
 static var previews: some View {
 TransactionsView()
 }
 }
 */
