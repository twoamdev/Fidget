//
//  WelcomeView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/24/22.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject private var signInViewModel = SignInViewModel()
    @ObservedObject private var signUpViewModel = SignUpViewModel()
    @State var showUserSignUpOnboarding = false
    
    var body: some View {
        NavigationView{
            
            if signUpViewModel.userSignUpStatus.creatingAccount(){
                createUserLoadPage
                    .transition(.slide)
                    .animation(.easeInOut, value: 2)
            }
            else{
                welcomePage
                    .transition(.slide)
                    .animation(.easeInOut, value: 2)
            }
            
        }
        .navigationBarTitle("", displayMode: .inline)
        .accentColor(AppColor.primary)
    }
    
    var welcomePage : some View{
        VStack(){
            Text("Welcome to Pig")
                .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                .padding()
            signInOrUpSelection
        }
    }
    
    var signInOrUpSelection : some View {
        VStack{
            NavigationLink(destination: SignInView()
                            .environmentObject(signInViewModel)) {
                StandardButton(label: "SIGN IN", function: {}).primaryButtonLabelLarge
                    .padding(.horizontal)
                    .padding(.horizontal)
            }
            .navigationBarTitle("", displayMode: .inline)
            
            
            NavigationLink(destination:
                            SignUpView(showOnboarding: $showUserSignUpOnboarding)
                            .environmentObject(signUpViewModel)
                           , isActive: $showUserSignUpOnboarding)
            {
                StandardButton(label: "CREATE ACCOUNT", function: {}).normalButtonLabelLarge
                    .padding(.horizontal)
                    .padding(.horizontal)
            }
        }
    }
    
    var createUserLoadPage : some View{
        VStack{
            Text("loading user account process")
            LottieView(name: "rocket_anim", loopMode: .loop)
                .frame(width: 300, height: 300)
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
