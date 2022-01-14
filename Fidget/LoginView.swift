//
//  LoginView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI



struct LoginView: View {
    @EnvironmentObject var appState: AppState
    
    @State private var username: String = ""
    @State private var password: String = ""
    var body: some View {
        
        VStack{
            Spacer()
            Text("Fidget")
                .font(.title)
            TextField("Username", text: $username)
                .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
            
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .padding(EdgeInsets(top: 0, leading: 50, bottom: 10, trailing: 50))
                .textFieldStyle(.roundedBorder)
            Button("login"){
                appState.loggedIn = true
            }
            .foregroundColor(.white)
            .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
            .background(Color.blue)
            .cornerRadius(25)
            
            
            
            Spacer()
            Spacer()
        }
        
        
        
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
       LoginView()
    }
}

