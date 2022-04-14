//
//  WelcomeView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/24/22.
//

import SwiftUI

struct WelcomeView: View {
    @Environment(\.scenePhase) var scenePhase
    @ObservedObject private var homeVM : HomeViewModel = HomeViewModel()
    @ObservedObject private var signInViewModel = SignInViewModel()
    @ObservedObject private var signUpViewModel = SignUpViewModel()
    @ObservedObject private var budgetMonitor = BudgetMonitor(timeInterval: 0.5)
    
    @State var showUserSignUpOnboarding = false

    @State var show = false // delete
    
    var body: some View {
        
            let signedIn = (signInViewModel.showHome || signUpViewModel.showHome)
            
            if signedIn {
                HomeView()
                    .environmentObject(homeVM)
                    .environmentObject(signInViewModel)
                    .environmentObject(signUpViewModel)
                    .onAppear(perform: {
                        self.budgetMonitor.startMonitoring()
                        print("\non appear home view started monitoring")
                    })
                    .onDisappear(perform: {
                        self.budgetMonitor.stopMonitoring()
                    })
                    .onChange(of: scenePhase, perform: { phase in
                        if phase == .active {
                            print("\nACTIVE from BG, started monitoring")
                            self.budgetMonitor.startMonitoring()
                        }
                    })
                    .onChange(of: self.homeVM.budget.id, perform: { _ in
                        print("\nuser has a budget data changed")
                        self.budgetMonitor.startMonitoring()
                    })
                    .onChange(of: self.budgetMonitor.interrupt, perform: { _ in
                        //interrupt ready to help us out
                        print("\ninterrupt triggered")
                        self.homeVM.renewBudget()
                        self.budgetMonitor.delayMonitoringUntilMidnight()
                    })

                    
            }
            else{
                NavigationView{
                    welcomePage
                }
                .navigationBarTitle("", displayMode: .inline)
                .accentColor(AppColor.primary)
            }
        
    }
    
    var welcomePage : some View{
        VStack(){
            
            Text("Welcome to Pig")
                .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                .kerning(AppFonts.titleKerning)
                .padding()
            signInOrUpSelection
        }
    }
    
    var signInOrUpSelection : some View {
        VStack{
            NavigationLink(destination: SignInView()
                            .environmentObject(signInViewModel)
                            .environmentObject(homeVM)
                            .onDisappear(perform: {
                signInViewModel.clearUserInputs()
            })
            ) {
                StandardButton(label: "SIGN IN", function: {}).primaryButtonLabelLarge
                    .padding(.horizontal)
            }
            .navigationBarTitle("", displayMode: .inline)
            
            
            NavigationLink(destination:
                            SignUpView(showOnboarding: $showUserSignUpOnboarding)
                            .environmentObject(signUpViewModel)
                            .environmentObject(homeVM)
                           , isActive: $showUserSignUpOnboarding)
            {
                StandardButton(label: "CREATE ACCOUNT", function: {}).normalButtonLabelLarge
                    .padding(.horizontal)
            }
        }
    }
}


/*
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
*/
