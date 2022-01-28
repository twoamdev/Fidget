//
//  MainContentView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/27/22.
//

import SwiftUI

struct MainContentView: View {
    @ObservedObject var signInViewModel = SignInViewModel()
    var body: some View {
        
        if signInViewModel.signedIn {
            TabBarMainView()
                .environmentObject(signInViewModel)
        }
        else{
            SignInView(userSignedOut: signInViewModel.userSignedOut)
                .environmentObject(signInViewModel)
        }
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
