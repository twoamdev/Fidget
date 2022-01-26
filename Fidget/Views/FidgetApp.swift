//
//  FidgetApp.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

class AppState: ObservableObject{
    @Published var loggedIn: Bool
    init(loggedIn: Bool){
        self.loggedIn = loggedIn
    }
}


@main
struct FidgetApp: App {
    @ObservedObject var appState = AppState(loggedIn: false)
    let signUpViewModel = SignUp()
    
    var body: some Scene {
        WindowGroup {
            if appState.loggedIn{
                MainView()
                    .environmentObject(appState)
            }else{
                LoginView(signUpViewModel: signUpViewModel)
                    .environmentObject(appState)
            }
            
        }
    }
}
