//
//  FidgetApp.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI
import Firebase

class AppState: ObservableObject{
    @Published var loggedIn: Bool
    init(loggedIn: Bool){
        self.loggedIn = loggedIn
    }
}


@main
struct FidgetApp: App {
    @ObservedObject var appState = AppState(loggedIn: false)
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            if appState.loggedIn{
                MainView()
                    .environmentObject(appState)
            }else{
                let signUpViewModel = SignUpViewModel()
                LoginView()
                    .environmentObject(appState)
                    .environmentObject(signUpViewModel)
            }
            
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
