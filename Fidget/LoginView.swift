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
    
    
    let appFontMainRegular = AppFonts().mainFontBold
    var body: some View {
        
        VStack{
            Spacer()
            Text("Fidget")
            //.font(.title)
                .tracking(-2.0)
                .font(Font.custom(appFontMainRegular,size: 50))
                .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                .foregroundColor(ColorPallete().tempFGColor)
            
            ZStack(){
                Rectangle()
                    .foregroundColor(ColorPallete().tempNeutralColor)
                    .frame(width: .infinity, height: 40, alignment: .center)
                TextField("Username", text: $username)
                    .font(Font.custom(appFontMainRegular,size:20))
                    .foregroundColor(ColorPallete().tempFGColor)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    .accentColor(ColorPallete().tempPrimaryColor)
            }
            .cornerRadius(5)
            .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
            
            ZStack(){
                Rectangle()
                    .foregroundColor(ColorPallete().tempNeutralColor)
                    .frame(width: .infinity, height: 40, alignment: .center)
                SecureField("Password", text: $password)
                    .font(Font.custom(appFontMainRegular,size:20))
                    .foregroundColor(ColorPallete().tempFGColor)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 0))
                    .accentColor(ColorPallete().tempPrimaryColor)
            }
            .cornerRadius(5)
            .padding(EdgeInsets(top: 0, leading: 50, bottom: 0, trailing: 50))
            
            /*
             SecureField("Password", text: $password)
             .font(Font.custom(appFontMainRegular,size:15))
             .padding(EdgeInsets(top: 0, leading: 50, bottom: 10, trailing: 50))
             .textFieldStyle(.roundedBorder)
             .foregroundColor(ColorPallete().tempFGColor)*/
            HStack(){
                Spacer()
                /*
                 Button(""){
                 appState.loggedIn = true
                 }
                 .font(Font.custom(appFontMainRegular,size:15))
                 .foregroundColor(.white)
                 .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                 .background(ColorPallete().tempNeutralColor)
                 .cornerRadius(100)
                 */
                Button(action: {
                    appState.loggedIn = true
                }, label: {
                    //Image(systemName:"chevron.right")
                    Image(systemName:"chevron.right")
                        //.resizable().frame(width: 20, height: 20)
                        .frame(width: 60, height: 60)
                        .foregroundColor(ColorPallete().tempFGColor)
                        .background(ColorPallete().tempNeutralColor)
                        .clipShape(Circle())
                })
                //.buttonStyle(PlainButtonStyle())
                   
                //.cornerRadius(100)
            }
            .padding(EdgeInsets(top: 10, leading: 50, bottom: 10, trailing: 50))
            
            
            
            
            Spacer()
            Spacer()
        }
        
        .background(ColorPallete().tempPrimaryColor)
        
        
        
        
    }
    
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

