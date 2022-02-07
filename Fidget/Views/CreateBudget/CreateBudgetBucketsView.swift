//
//  CreateBudgetBucketsView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/6/22.
//

import SwiftUI

struct CreateBudgetBucketsView: View {
    @EnvironmentObject var bucketsViewModel : BucketsViewModel
    @Binding var showCreateBudgetNavigation : Bool
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
                ForEach(buckets, id: \.self) { bucket in
                    BucketMiniView(bucket: bucket)
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
                    
                    bucketsViewModel.createBudget(Budget(budgetName: budgetName, buckets, incomeItems))
                    
                    if bucketsViewModel.budgetCreated {
                        showCreateBudgetNavigation = false
                    }
                } ){
                    Image(systemName: "checkmark")
                        //.resizable()
                        .padding(6)
                        .frame(width: 40, height: 40)
                        .background(Color.green)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
    }
}

struct CreateBudgetBucketsView_Previews: PreviewProvider {
    static var previews: some View {
        CreateBudgetBucketsView(showCreateBudgetNavigation: .constant(true), incomeItems: .constant([Budget.IncomeItem()]) , budgetName: "MY BUDGET")
    }
}

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
