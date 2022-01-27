//
//  FidgetApp.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI
import Firebase


@main
struct FidgetApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            let signInViewModel = SignInViewModel()
            if signInViewModel.signedIn{
                TabBarMainView()
                    .environmentObject(signInViewModel)
                    .onAppear{
                        signInViewModel.signedIn = signInViewModel.isSignedIn
                    }
            }
            else{
                SignInView()
                    .environmentObject(signInViewModel)
                    .onAppear{
                        signInViewModel.signedIn = signInViewModel.isSignedIn
                    }
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
