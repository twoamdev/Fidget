//
//  CreateBudgetBucketsView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/6/22.
//

import SwiftUI

struct CreateBudgetBucketsView: View {
    @EnvironmentObject var homeViewModel : HomeViewModel
    @Binding var showBudgetNavigationViews : Bool
    @Binding var incomeItems : [Budget.IncomeItem]
    @State var budgetName : String
    @State var buckets : [Bucket] = []
    @State var showAddBucketView : Bool = false
    
    func removeItem(at offsets: IndexSet) {
        buckets.remove(atOffsets: offsets)
    }
    
    var body: some View {
        VStack(){
            Text("Create Buckets")
            List{
                ForEach(0..<buckets.count, id: \.self) { i in
                    BucketMiniView(bucket: buckets[i])
                        .padding()
                }
                .onDelete(perform: removeItem)
                .animation(.easeInOut)
                
            }
            .toolbar{
                EditButton()
            }
            HStack(){
                Image(systemName: "plus")
                    .resizable()
                    .padding(6)
                    .frame(width: 40, height: 40)
                    .background(Color.blue)
                    .clipShape(Circle())
                    .foregroundColor(.white)
                    .padding()
                    .sheet(isPresented: $showAddBucketView) {
                        AddBucketView(showAddBucketView: $showAddBucketView, buckets: $buckets)
                    }
                    .onTapGesture {
                        showAddBucketView.toggle()
                    }
                Button(action: {
                    
                    homeViewModel.saveNewBudget(Budget(budgetName, buckets, incomeItems))
                    self.showBudgetNavigationViews.toggle()
                    
                } ){
                    Image(systemName: "checkmark")
                        //.resizable()
                        .padding(6)
                        .frame(width: 50, height: 50)
                        .background(Color.green)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
        .navigationBarTitle("Final Step", displayMode: .inline)
    }
}

/*
struct CreateBudgetBucketsView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBudgetBucketsView(showCreateBudgetNavigation: .constant(true), incomeItems: .constant([Budget.IncomeItem()]) , budgetName: "MY BUDGET")
    }
}
 */

struct BucketMiniView : View{
    @State var bucket : Bucket
    var body: some View{
        VStack(){
            Text(bucket.name)
            Text("\(Int(bucket.value))/\(Int(bucket.capacity))")
            Text(bucket.rolloverEnabled ? "Rollover Enabled" : "Rollover Disabled")
        }
        
    }
}
