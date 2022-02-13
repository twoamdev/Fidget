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
    
    func didDismiss(){
        if let bucket = buckets.first {
            homeViewModel.addBucketToBudget(bucket)
            buckets = []
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(){
                if homeViewModel.loading && !homeViewModel.userHasBudget{
                    ProgressView()
                }
                else{
                    if homeViewModel.userHasBudget {
                        HStack(){
                            Menu {
                                let userBudgets = homeViewModel.userBudgetNames()
                                ForEach(0..<userBudgets.count, id: \.self) { i in
                                    BudgetMenuItemView(name: userBudgets[i])
                                }
                            } label: {
                                Text(homeViewModel.budget.name)
                            }
                            .onTapGesture {
                                print("FETCH")
                            }
                            Image(systemName: "plus")
                                .resizable()
                                .padding(6)
                                .frame(width: 40, height: 40)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                                .padding()
                                .sheet(isPresented: $showAddBucketView, onDismiss: didDismiss) {
                                    AddBucketView(showAddBucketView: $showAddBucketView, buckets: $buckets)
                                }
                                .onTapGesture {
                                    showAddBucketView.toggle()
                                }
                        }
                            
                            ScrollView{
                                let buckets = homeViewModel.budget.buckets
                                ForEach(0..<buckets.count, id: \.self) { i in
                                    BucketCardView(bucket: buckets[i]).environmentObject(homeViewModel)
                                }
                            }
                    }
                    else{
                        StartBudgetView(showBudgetNavigationViews: $showStartBudgetView).environmentObject(homeViewModel)
                    }
                }
            }
        }
        
    }
    
    
}


struct BudgetMenuItemView : View{
    @State var name : String

    var body: some View{
        Button(action: {
            
        }) {
            Label(name, systemImage: "arrow.triangle.2.circlepath.doc.on.clipboard")
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

