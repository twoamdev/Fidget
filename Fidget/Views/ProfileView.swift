//
//  ProfileView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        
        
         Button("logout()"){
         appState.loggedIn = false
         }
         .foregroundColor(.white)
         .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
         .background(Color.blue)
         .cornerRadius(25)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
