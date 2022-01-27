//
//  MainView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct TabBarMainView: View {
    @EnvironmentObject var signInViewModel: SignInViewModel
    init() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = UIColor(ColorPallete().bgColor)
        UITabBar.appearance().barTintColor = UIColor(ColorPallete().bgColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor(ColorPallete().mediumFGColor)
    }
    var body: some View {
        
        
        TabView(){
            AllocateView()
                .tabItem {
                    
                    Label("Allocate", systemImage: "text.bubble.fill")
                        
                        
                }
                
            BucketsView()
                .tabItem {
                    Label("Buckets", systemImage: "archivebox.fill")
                }
            OverviewView()
                .tabItem {
                    Label("Overview", systemImage: "globe")
                }
            ProfileView()
                
                .tabItem {
                    Label("Profile", systemImage: "person.circle.fill")
                }
                .environmentObject(signInViewModel)
        }
        .accentColor(ColorPallete().accentColor)
       
        
        
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        TabBarMainView()
    }
}
