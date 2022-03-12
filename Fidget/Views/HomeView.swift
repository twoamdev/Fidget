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
            if !signUpVM.isProcessingSignUp && !signInVM.isSigningIn{
                homeViewTabBar
            }
            else{
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
                    .environmentObject(profileViewModel)
                    .environmentObject(transactionViewModel)
                    .environmentObject(signInVM)
                    .environmentObject(signUpVM)
                    
                 
            }
            
        }
    }
    
    var loadScreen : some View {
        VStack{
            if signInVM.isSigningIn{
                Text("SIGN IN BOOTING")
                ProgressView()
            }
            else{
                VStack{
                    let message : String = signUpVM.userSignUpStatus.phaseMessage()
                    Text(message)
                    LottieView(name: "rocket_anim", loopMode: .loop)
                        .frame(width: 200, height: 200)
                }
            }
        }
        
    }
}

