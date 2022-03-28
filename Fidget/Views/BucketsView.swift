//
//  BucketsView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct BucketsView: View {
    @EnvironmentObject var homeViewModel : HomeViewModel
    @EnvironmentObject var transactionViewModel : TransactionViewModel
    @ObservedObject var bucketSheetVM = BucketSheetViewModel()
    @State var showStartBudgetView : Bool = false
    @State var showAddBucketView : Bool = false
    @State var buckets : [Bucket] = []
    @State var transactions : [Transaction] = []
    @State private var selectedDate = Date.now
    @State var displayDatePicker = false
    @State var showBucketSheet = false


    
    var body: some View {
        VStack{
            if homeViewModel.userHasBudget {
                displayBudgetBuckets
                Spacer()
            }
            else{
                createBudget
            }
        }
    }
    
    var displayBudgetBuckets : some View {
        
        ZStack{
            bucketsList
                .blur(radius: displayDatePicker ? 20 : 0)
            
            topBanner
            if displayDatePicker {
                calendar
            }
        }
    }
    
    var createBudget : some View {
        VStack{
            NavigationView {
                VStack{
                    StartBudgetView(showBudgetNavigationViews: $showStartBudgetView).environmentObject(homeViewModel)
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
    
    
    var topBanner : some View {
        VStack(){
            HStack(){
                Button(action: {
                    displayDatePicker.toggle()
                }, label: {
                    Image(systemName: "calendar")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(AppColor.fg)
                })
                    .padding()
                Spacer()
                if displayDatePicker {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray.opacity(0))
                        .padding()
                }
                else{
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(AppColor.primary)
                        .padding()
                        .sheet(isPresented: $showAddBucketView, onDismiss: didDismiss) {
                            AddBucketView(showAddBucketView: $showAddBucketView, buckets: $buckets, transactions: $transactions)
                        }
                        .onTapGesture {
                            UXUtils.hapticButtonPress()
                            showAddBucketView.toggle()
                        }
                }
            }
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
            .padding()
            Spacer()
        }
    }
    
    var bucketsList : some View {
        VStack(){
            let buckets = homeViewModel.budget.buckets
            if buckets.count == .zero{
                Text("No Buckets Yet.")
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.inputFieldSize))
            }
            else{
                
                VStack{
                    
                    List{
                        
                        Rectangle()
                            .frame(width: 60, height: 80)
                            .opacity(0)
                            .listRowSeparator(.hidden)
                        
                        ForEach(0..<buckets.count, id: \.self) { i in
                            let bucket = buckets[i]
                            let balance = homeViewModel.bucketBalance(bucket.id)
                            VStack(spacing: 0){
                                BucketCardView(bucket: bucket, bucketBalance: balance)
                                    .padding(.vertical)
                                    .onTapGesture {
                                        bucketSheetVM.storeCurrentBucketData(bucket, balance)
                                        showBucketSheet.toggle()
                                        UXUtils.hapticButtonPress()
                                    }
                            
                                Divider()
                            }
                            .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteBucket)
                        .onMove { indexSet, offset in
                            homeViewModel.budget.buckets.move(fromOffsets: indexSet, toOffset: offset)
                        }
                        
                    }
                    .listStyle(.plain)
                    .clipped()
                    
                }
                
                .sheet(isPresented: $showBucketSheet, onDismiss: {
                    let wasEdited = bucketSheetVM.editBucketIfNecessary()
                    if wasEdited {
                        homeViewModel.updateExistingBucketInBudget(bucketSheetVM.getBucket())
                    }
                }, content: {
                    BucketSheetView(showSheet: $showBucketSheet)
                                    .environmentObject(homeViewModel)
                                    .environmentObject(transactionViewModel)
                                    .environmentObject(bucketSheetVM)
                })
                
            }
        }
    }
    
    var calendar : some View {
        VStack(){
            Rectangle()
                .frame(height: 60)
                .foregroundColor(Color.white.opacity(0))
                .padding()
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .padding()
            Spacer()
        }
    }
    
    func didDismiss(){
        if let bucket = buckets.first {
            if let transaction = transactions.first {
                homeViewModel.addBucketWithTransactionToBudget(bucket, transaction)
                buckets = []
                transactions = []
            }
            else{
                homeViewModel.addBucketToBudget(bucket)
                buckets = []
                transactions = []
            }
        }
    }
    
    func deleteBucket(at offsets: IndexSet){
        homeViewModel.removeBucketFromBudget(offsets)
    }
    
}


/*
 struct BucketsView_Previews: PreviewProvider {
 static var previews: some View {
 BucketsView()
 }
 }
 
 */

