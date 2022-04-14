//
//  CreateBudgetBucketsView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/6/22.
//

import SwiftUI

struct CreateBucketsView: View {
    @EnvironmentObject var homeViewModel : HomeViewModel
    @Binding var showBudgetNavigationViews : Bool
    @Binding var incomeItems : [Budget.IncomeItem]
    @State var buckets : [Bucket] = []
    @State var transactions : [Transaction] = []
    @State var showAddBucketView : Bool = false
    var budgetDataUtils : BudgetDataUtils = BudgetDataUtils()
    
    func removeItem(at offsets: IndexSet) {
        buckets.remove(atOffsets: offsets)
    }
    
    var body: some View {
        VStack(){
            HStack{
                Text("Create Buckets")
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                    .kerning(AppFonts.titleKerning)
                Spacer()
            }
            .padding()
            
            if buckets.count == .zero {
                
                VStack{
                    Spacer()
                    Text("No Buckets Created Yet.")
                        .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.inputFieldSize))
                    Spacer()
                }
                
            }
            else{
                List{
                    ForEach(0..<buckets.count, id: \.self) { i in
                        let bucket = buckets[i]
                        let balance = budgetDataUtils.calculateBalance(transactions, bucket.id)
                        BucketMiniView(bucket: bucket, bucketBalance: balance)
                            .padding(.horizontal)
                    }
                    .onDelete(perform: removeItem)
                    
                    
                }
                .listStyle(.plain)
                .toolbar{
                    EditButton()
                }
            }
            
            VStack(){
                StandardButton(label: "ADD BUCKET", function: {
                    UXUtils.hapticButtonPress()
                    showAddBucketView.toggle()
                }).normalButtonLarge
                    .padding(.horizontal)
                    .sheet(isPresented: $showAddBucketView) {
                        AddBucketView(showAddBucketView: $showAddBucketView, buckets: $buckets, transactions: $transactions)
                    }
                
                /*
                 StandardButton(label: "CONTINUE", function: {
                 //homeViewModel.saveNewBudget(budgetName, buckets, incomeItems, transactions)
                 //self.showBudgetNavigationViews.toggle()
                 }).primaryButtonLarge
                 .padding(.horizontal)
                 .disabled(buckets.isEmpty)
                 
                 */
                
                if(buckets.isEmpty)
                {
                    StandardButton(lockedStyle: true, label: "CONTINUE").primaryButtonLabelLarge
                        .padding(.horizontal)
                }
                else{
                    NavigationLink(destination:
                                    FinalizeBudgetView(showBudgetNavigationViews: $showBudgetNavigationViews, incomeItems : $incomeItems,
                                                       buckets : $buckets, transactions : $transactions)
                                    .environmentObject(homeViewModel))
                    {
                        StandardButton(label: "CONTINUE").primaryButtonLabelLarge
                            .padding(.horizontal)
                    }
                    .isDetailLink(false)
                    .navigationBarTitle("", displayMode: .inline)
                }
                
                
                
            }
            .padding(.vertical)
        }
        .navigationBarTitle("", displayMode: .inline)
    }
}


struct BucketMiniView : View{
    @State var bucket : Bucket
    var bucketBalance : Double
    var body: some View{
        VStack(alignment: .leading){
            HStack{
                Text(bucket.name)
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.inputFieldSize))
                Spacer()
                StandardUserTextHelper(message: "Rollover", indicator: $bucket.rolloverEnabled)
            }
            Text("$\(Int(bucketBalance)) / \(Int(bucket.capacity))")
                .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.inputFieldSize))
            
        }
    }
}
