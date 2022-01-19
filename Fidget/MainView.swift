//
//  MainView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    init() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = UIColor(ColorPallete().tempPrimaryColor)
        UITabBar.appearance().barTintColor = UIColor(ColorPallete().tempPrimaryColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor(ColorPallete().tempNeutralColor)
       

    }
    var body: some View {
        
        
        TabView(){
            AllocateView()
                .tabItem {
                    
                    Label("", systemImage: "text.bubble.fill")
                        
                        
                }
                
            BucketsView()
                .tabItem {
                    Label("", systemImage: "archivebox.fill")
                }
            OverviewView()
                .tabItem {
                    Label("", systemImage: "globe")
                }
            ProfileView()
                
                .tabItem {
                    Label("", systemImage: "person.circle.fill")
                }
                .environmentObject(appState)
        }
        .accentColor(ColorPallete().tempFGColor)
        
        
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
