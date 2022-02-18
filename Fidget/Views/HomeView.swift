//
//  MainView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    @ObservedObject var homeViewModel : HomeViewModel = HomeViewModel()
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
                BucketsView()
                    .tabItem {
                        Label("Buckets", systemImage: "archivebox.fill")
                    }
                    .environmentObject(homeViewModel)
                /*
                    .onAppear(perform: {
                         homeViewModel.fetchBudget()
                    } )*/
                OverviewView()
                    .tabItem {
                        Label("Overview", systemImage: "globe")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle.fill")
                    }
                    .environmentObject(signInViewModel)
                    .environmentObject(homeViewModel)
            }
            //.accentColor(ColorPallete().accentColor)
            
        }        
    }
}

