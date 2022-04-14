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
    
    @ObservedObject var transactionViewModel : TransactionViewModel = TransactionViewModel()
    @ObservedObject var profileViewModel : ProfileViewModel = ProfileViewModel()
    @ObservedObject var bucketSheetVM = BucketSheetViewModel()
    
    @State var showChangeUsername = false
    @State var showDeleteView = false
    @State var showProfileInfo = false
    @State var showChangeName = false
    @State var showManageBudgets = false
    
    init() {
       // UITabBar.appearance().backgroundColor = UIColor(AppColor.bg)
        //UITabBar.appearance().barTintColor = UIColor(AppColor.bg)
        let tabBarAppeareance = UITabBarAppearance()
        tabBarAppeareance.shadowColor = UIColor(AppColor.bg) // For line separator of the tab bar
        tabBarAppeareance.backgroundColor = UIColor(AppColor.bg) // For background color
        UITabBar.appearance().standardAppearance = tabBarAppeareance
        UITabBar.appearance().unselectedItemTintColor = UIColor(AppColor.normalMoreContrast)
    }
    
    
    
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
                    .environmentObject(bucketSheetVM)

                
                OverviewView()
                    .tabItem {
                        Label("Overview", systemImage: "globe")
                    }
                    .environmentObject(homeVM)
                    .environmentObject(transactionViewModel)

                
                ProfileView(showDeleteView: $showDeleteView, showProfileInfo : $showProfileInfo, showChangeUsername : $showChangeUsername, showChangeName: $showChangeName, showManageBudgets : $showManageBudgets)
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
                        self.showManageBudgets = false
                    })
            }
            .accentColor(AppColor.primary)
            
        }
    }
    
    var loadScreen : some View {
        VStack{
            Text("LOADING PLACEHOLDER")
                .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.inputFieldSize))
                .foregroundColor(AppColor.normalMoreContrast)
            LottieView(name: "rocket_anim", loopMode: .loop)
                .frame(width: 200, height: 200)
        }
        
    }
}

