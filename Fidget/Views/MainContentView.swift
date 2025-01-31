//
//  MainContentView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/27/22.
//

import SwiftUI


struct MainContentView: View {
    @State private var showLogo = true
    
    var body: some View {
        VStack(){
            
            if showLogo {
                logoScreen
                    .transition(.moveInTrailingMoveOutLeading)
            }
            else{
                WelcomeView()
                    .transition(.moveInTrailingMoveOutTrailing)
                    
            }
            
        }
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    showLogo.toggle()
                }
                
            }
        })
    }
    
    var logoScreen : some View {
        VStack(){
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .frame(width: 60, height: 60)
                .padding()
                .foregroundColor(AppColor.normalMoreContrast)
            Text("PLACEHOLDER FOR GRAPHIC")
                .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.inputFieldSize))
                .foregroundColor(AppColor.normalMoreContrast)
        }
    }
}

struct MainContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
    }
}
