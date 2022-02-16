//
//  BucketsView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct BucketsView: View {
    @EnvironmentObject var homeViewModel : HomeViewModel
    @State var showStartBudgetView : Bool = false
    @State var showAddBucketView : Bool = false
    @State var buckets : [Bucket] = []
    @State private var selectedDate = Date.now
    @State var displayDatePicker = false
    
    func didDismiss(){
        if let bucket = buckets.first {
            homeViewModel.addBucketToBudget(bucket)
            buckets = []
        }
    }
    
    func deleteBucket(at offsets: IndexSet){
        homeViewModel.removeBucketFromBudget(offsets)
        print("OFFSETS: \(offsets)")
        print("REMOVE BUCKET")
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
                            .frame(width: 40, height: 40)
                            .foregroundColor(.black)
                    })
                    .padding()
                    
                    
                    Spacer()
                    
                    if displayDatePicker {
                        Image(systemName: "plus")
                            .resizable()
                            //.padding(6)
                            .frame(width: 40, height: 40)
                            //.background(Color.blue)
                            //.clipShape(Circle())
                            .foregroundColor(.gray)
                            .padding()
                    }
                    else{
                        Image(systemName: "plus")
                            .resizable()
                            //.padding(6)
                            .frame(width: 40, height: 40)
                            //.background(Color.blue)
                            //.clipShape(Circle())
                            .foregroundColor(.black)
                            .padding()
                            .sheet(isPresented: $showAddBucketView, onDismiss: didDismiss) {
                                AddBucketView(showAddBucketView: $showAddBucketView, buckets: $buckets)
                            }
                            .onTapGesture {
                                showAddBucketView.toggle()
                            }
                    }
                }
                .frame(height: 60)
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 12.0, style: .continuous))
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
                    BucketCardView(bucket: buckets[i])
                        .padding(.vertical)
                        
                }
                .onDelete(perform: deleteBucket)
                .onMove { indexSet, offset in
                    homeViewModel.budget.buckets.move(fromOffsets: indexSet, toOffset: offset)
                }
            }
            .listStyle(.plain)
            
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

