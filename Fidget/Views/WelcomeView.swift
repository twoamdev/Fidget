//
//  WelcomeView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/24/22.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject private var homeVM : HomeViewModel = HomeViewModel()
    @ObservedObject private var signInViewModel = SignInViewModel()
    @ObservedObject private var signUpViewModel = SignUpViewModel()
    @State var showUserSignUpOnboarding = false

    
    var body: some View {
        NavigationView{
            let signedIn = (signInViewModel.showHome || signUpViewModel.showHome)
            
            if signedIn {
                HomeView()
                    .environmentObject(homeVM)
                    .environmentObject(signInViewModel)
                    .environmentObject(signUpViewModel)
            }
            else{
                welcomePage
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .accentColor(AppColor.primary)
    }
    
    var welcomePage : some View{
        VStack(){
            Spacer()
            Spacer()
            
            Text("Welcome to Pig")
                .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                .kerning(AppFonts.titleKerning)
                .padding()
            signInOrUpSelection
            
            Spacer()
            Spacer()
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
