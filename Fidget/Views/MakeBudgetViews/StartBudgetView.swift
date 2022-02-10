//
//  AddBudgetView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/8/22.
//

import SwiftUI

struct StartBudgetView: View {
    @EnvironmentObject var homeViewModel : HomeViewModel
    @Binding var showBudgetNavigationViews : Bool
    
    var body: some View {
        VStack(){
            
            NavigationLink(destination: LinkSharedBudgetView())
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
            if homeViewModel.userHasBudget {
                NavigationLink(destination: CreateBudgetView(showBudgetNavigationViews: $showBudgetNavigationViews)
                                .environmentObject(homeViewModel))
                {
                    Image(systemName: "plus")
                        .resizable()
                        .padding(9)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
                .isDetailLink(false)
            }
            else{
                NavigationLink(destination: CreateBudgetView(showBudgetNavigationViews: $showBudgetNavigationViews)
                                .environmentObject(homeViewModel), isActive: $showBudgetNavigationViews)
                {
                    Image(systemName: "plus")
                        .resizable()
                        .padding(9)
                        .frame(width: 60, height: 60)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
            }
            Text("Create a Budget")
            Spacer()
        }
    }
}

/*

struct AddBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        AddBudgetView(showCreateBudgetNavigation: .constant(false))
    }
}

*/
