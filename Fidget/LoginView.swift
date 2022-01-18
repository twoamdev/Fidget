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
   
    
    let appFontPrimary = "DMSans-Regular"
    var body: some View {
        
        VStack{
            Spacer()
            Text("Fidget")
            //.font(.title)
                .font(Font.custom(appFontPrimary,size: 40, relativeTo: .title))
                .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                .foregroundColor(ColorPallete().tempTitleColor)
            TextField("Username", text: $username)
                .font(Font.custom(appFontPrimary,size:15))
                .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
            
                .textFieldStyle(.roundedBorder)
                .foregroundColor(ColorPallete().tempFGColor)
            SecureField("Password", text: $password)
                .font(Font.custom(appFontPrimary,size:15))
                .padding(EdgeInsets(top: 0, leading: 50, bottom: 10, trailing: 50))
                .textFieldStyle(.roundedBorder)
                .foregroundColor(ColorPallete().tempFGColor)
            HStack(){
                Spacer()
                Button("Log In"){
                    appState.loggedIn = true
                }
                .font(Font.custom(appFontPrimary,size:15))
                .foregroundColor(.white)
                .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                .background(ColorPallete().tempFGColor)
                .cornerRadius(7)
            }
            .padding(EdgeInsets(top: 0, leading: 50, bottom: 10, trailing: 50))
            
            
            
            
            Spacer()
            Spacer()
        }
            
            .background(ColorPallete().tempBGColor)
        
        
        
        
    }
        
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

