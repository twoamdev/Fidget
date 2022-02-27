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
            if signUpViewModel.userSignUpStatus.accountIsProcessing{
                if !signUpViewModel.userSignUpStatus.success() {
                    Text("loading user account process")
                    ProgressView()
                }
                else{
                    VStack(){
                        Text("Welcome to Pig")
                            .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                            .padding()
                        navigationLinks
                        
                    }
                }
            }
            else{
                VStack(){
                    Text("Welcome to Pig")
                        .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                        .padding()
                    navigationLinks
                    
                }
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .accentColor(AppColor.primary)
    }
    
    var navigationLinks : some View {
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
}

/*
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
    }
}
*/
