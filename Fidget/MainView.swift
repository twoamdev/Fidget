//
//  MainView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        
        
        TabView{
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
                .environmentObject(appState)
        }
        
        
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
