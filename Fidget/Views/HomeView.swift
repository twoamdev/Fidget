//
//  MainView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @ObservedObject var profileViewModel : ProfileViewModel = ProfileViewModel()
    @ObservedObject var homeViewModel : HomeViewModel = HomeViewModel()
    @ObservedObject var transactionViewModel : TransactionViewModel = TransactionViewModel()
    
    /*
    init() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = UIColor(ColorPallete().bgColor)
        UITabBar.appearance().barTintColor = UIColor(ColorPallete().bgColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor(ColorPallete().mediumFGColor)
    }
     */
    var body: some View {
        
        ZStack(){
            TabView(){
                TransactionsView()
                    .tabItem {
                        Label("Transactions", systemImage: "text.bubble.fill")
                    }
                    .environmentObject(homeViewModel)
                    .environmentObject(transactionViewModel)
                BucketsView()
                    .tabItem {
                        Label("Buckets", systemImage: "archivebox.fill")
                    }
                    .environmentObject(homeViewModel)
                    .environmentObject(transactionViewModel)
                /*
                    .onAppear(perform: {
                         homeViewModel.fetchBudget()
                    } )*/
                OverviewView()
                    .tabItem {
                        Label("Overview", systemImage: "globe")
                    }
                    .environmentObject(homeViewModel)
                    .environmentObject(transactionViewModel)
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle.fill")
                    }
                    .environmentObject(profileViewModel)
                    .environmentObject(signInViewModel)
                    .environmentObject(homeViewModel)
                    .environmentObject(transactionViewModel)
                    .onAppear(perform: {
                        profileViewModel.fetchProfile()
                    })
            }
            //.accentColor(ColorPallete().accentColor)
            
        }        
    }
}

