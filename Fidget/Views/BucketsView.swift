//
//  BucketsView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct BucketsView: View {
    @EnvironmentObject var homeViewModel : HomeViewModel
    @State var show : Bool = false
    var body: some View {
        NavigationView {
            VStack(){
                if homeViewModel.userHasBudget {
                    
                    HStack(){
                        
                        Menu {
                            ForEach(0..<homeViewModel.budgets.count, id: \.self) { i in
                                BudgetMenuItemView(name: homeViewModel.budgets[i].name,
                                                   menuItemIndex: i).environmentObject(homeViewModel)
                            }
                        } label: {
                            Text(homeViewModel.budgets[homeViewModel.currentBudgetIndex].name)
                        }
                    }
                    
                    
                    
                    ScrollView{
                        let buckets = homeViewModel.currentBudgetBuckets()
                        ForEach(0..<buckets.count, id: \.self) { i in
                            BucketCardView(bucket: buckets[i])
                            
                        }
                    }
                    
                }
                else{
                    StartBudgetView(showBudgetNavigationViews: $show).environmentObject(homeViewModel)
                }
            }
        }
        
    }
}

struct BudgetMenuItemView : View{
    @State var name : String
    @State var menuItemIndex: Int
    @EnvironmentObject var viewModel : HomeViewModel
    var body: some View{
        Button(action: {
            viewModel.setCurrentBudgetIndex(menuItemIndex)
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

