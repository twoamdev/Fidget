//
//  MainView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var homeVM : HomeViewModel
    @EnvironmentObject var signInVM : SignInViewModel
    @EnvironmentObject var signUpVM : SignUpViewModel

    @ObservedObject var profileViewModel : ProfileViewModel = ProfileViewModel()
    @ObservedObject var transactionViewModel : TransactionViewModel = TransactionViewModel()
    
    var body: some View {
        VStack{
            if homeVM.dataLoadedAfterSignIn{
                homeViewTabBar
            }
            else {
                loadScreen
            }
        }
    }
    
    var homeViewTabBar : some View {
        VStack{
            TabView(){
                TransactionsView()
                    .tabItem {
                        Label("Transactions", systemImage: "text.bubble.fill")
                    }
                    .environmentObject(homeVM)
                    .environmentObject(transactionViewModel)
                BucketsView()
                    .tabItem {
                        Label("Buckets", systemImage: "archivebox.fill")
                    }
                    .environmentObject(homeVM)
                    .environmentObject(transactionViewModel)
                OverviewView()
                    .tabItem {
                        Label("Overview", systemImage: "globe")
                    }
                    .environmentObject(homeVM)
                    .environmentObject(transactionViewModel)
                
                ProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person.circle.fill")
                    }
                    .environmentObject(homeVM)
                    .environmentObject(profileViewModel)
                    .environmentObject(signInVM)
                    .environmentObject(signUpVM)
                    
                 
            }
            
        }
    }
    
    var loadScreen : some View {
        VStack{
            Text("Setting Up Your Cool Stuff")
            LottieView(name: "rocket_anim", loopMode: .loop)
                .frame(width: 200, height: 200)
        }
        
    }
}

