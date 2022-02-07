//
//  BucketsView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct BucketsView: View {
    @ObservedObject var bucketsViewModel = BucketsViewModel()
    @State var showCreateBudgetNavigation : Bool = false
    var body: some View {
        NavigationView {
            VStack(){
                //ColorPallete().mediumFGColor.edgesIgnoringSafeArea(.all)
                if bucketsViewModel.userHasBudget {
                    Text("HERE'S THE LIST OF BUCKETS")
                    
                }
                else{
                    VStack(){
                        
                        NavigationLink(destination: AddSharedBudgetView())
                        {
                            Image(systemName: "person.fill.badge.plus")
                                .resizable()
                                .padding(10)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                        Text("Add a Shared Budget")
                        Spacer()
                        Divider()
                        Spacer()
                        NavigationLink(destination: CreateBudgetView(showCreateBudgetNavigation : $showCreateBudgetNavigation)
                                        .environmentObject(bucketsViewModel)
                        ,isActive: $showCreateBudgetNavigation)
                        {
                            Image(systemName: "plus")
                                .resizable()
                                .padding(9)
                                .frame(width: 60, height: 60)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                        }
                        Text("Create a Budget")
                        Spacer()
                    }
                }
            }
        }  
    }
}

struct BucketsView_Previews: PreviewProvider {
    static var previews: some View {
        BucketsView()
    }
}


