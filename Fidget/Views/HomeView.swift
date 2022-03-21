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
    
    @State var showChangeUsername = false
    @State var showDeleteView = false
    @State var showProfileInfo = false
    @State var showChangeName = false
    
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
                
                ProfileView(showDeleteView: $showDeleteView, showProfileInfo : $showProfileInfo, showChangeUsername : $showChangeUsername, showChangeName: $showChangeName)
                    .tabItem {
                        Label("Profile", systemImage: "person.circle.fill")
                    }
                    .environmentObject(homeVM)
                    .environmentObject(transactionViewModel)
                    .environmentObject(profileViewModel)
                    .environmentObject(signInVM)
                    .environmentObject(signUpVM)
                    .onDisappear(perform: {
                        self.showChangeUsername = false
                        self.showChangeName = false
                        self.showProfileInfo = false
                        self.showDeleteView = false
                    })
                 
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

