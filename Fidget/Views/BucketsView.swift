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
    @State var showStartBudgetView : Bool = false
    @State var showAddBucketView : Bool = false
    @State var buckets : [Bucket] = []
    @State var transactions : [Transaction] = []
    @State private var selectedDate = Date.now
    @State var displayDatePicker = false
    
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
    
    var body: some View {
        NavigationView {
            VStack(){
                if homeViewModel.loading && !homeViewModel.userHasBudget{
                    ProgressView()
                }
                else{
                    if homeViewModel.userHasBudget {
                        ZStack(){
                            
                            if displayDatePicker {
                                bucketsList
                                    .blur(radius: 20)
                                topBanner
                                calendar
                                
                            }
                            else{
                                bucketsList
                                topBanner
                            }
                        }
                        .navigationBarTitle("")
                        .navigationBarHidden(true)
                        
                    }
                    else{
                        StartBudgetView(showBudgetNavigationViews: $showStartBudgetView).environmentObject(homeViewModel)
                    }
                }
            }
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
                            .foregroundColor(.black)
                    })
                    .padding()
                    
                    
                    Spacer()
                    
                    if displayDatePicker {
                        Image(systemName: "plus")
                            .resizable()
                            //.padding(6)
                            .frame(width: 30, height: 30)
                            //.background(Color.blue)
                            //.clipShape(Circle())
                            .foregroundColor(.gray.opacity(0))
                            .padding()
                    }
                    else{
                        Image(systemName: "plus")
                            .resizable()
                            //.padding(6)
                            .frame(width: 30, height: 30)
                            //.background(Color.blue)
                            //.clipShape(Circle())
                            .foregroundColor(.black)
                            .padding()
                            .sheet(isPresented: $showAddBucketView, onDismiss: didDismiss) {
                                AddBucketView(showAddBucketView: $showAddBucketView, buckets: $buckets, transactions: $transactions)
                            }
                            .onTapGesture {
                                showAddBucketView.toggle()
                            }
                    }
                }
                .frame(height: 60)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
                .padding()
                
               

            
            
            Spacer()
        }
    }
    
    var bucketsList : some View {
        VStack(){
            List{
                let buckets = homeViewModel.budget.buckets
                
                
                    Rectangle()
                        .frame(height: 60)
                        .foregroundColor(Color.white.opacity(0))
                        .padding()
                
                        
                
                
                ForEach(0..<buckets.count, id: \.self) { i in
                    let bucket = buckets[i]
                    let balance = homeViewModel.bucketBalance(bucket.id)
                    ZStack(){
                        BucketCardView(bucket: bucket, bucketBalance: balance)
                            .padding(.vertical)
                            .background(.white)
                        NavigationLink(destination:
                                        BucketSheetView(bucket: bucket, bucketBalance: balance)
                                        .environmentObject(homeViewModel)
                                        .environmentObject(transactionViewModel))
                        {
                            EmptyView()
                        }.opacity(0)
                    }
                
                        
                }
                .onDelete(perform: deleteBucket)
                .onMove { indexSet, offset in
                    homeViewModel.budget.buckets.move(fromOffsets: indexSet, toOffset: offset)
                }
                
            }
            .listStyle(.plain)
            .clipped()
            
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
    
    
}


/*
 struct BucketsView_Previews: PreviewProvider {
 static var previews: some View {
 BucketsView()
 }
 }
 
 */

