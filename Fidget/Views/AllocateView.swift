//
//  AllocateView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct AllocateView: View {
    @State private var userMessage: String = ""
    @State private var moneyAmount: String = ""
    var body: some View {
        
        VStack{
            /*
            Text("Allocate")
                .font(Font.custom(AppFonts().mainFontRegular, size: 25))
                .frame(maxWidth: .infinity)
                .padding()
                .background(ColorPallete().tempPrimaryColor)
                .foregroundColor(Color.white)
                */
           
            Spacer()
            HStack{
                TextField("/ :", text: $userMessage)
                    .font(Font.custom(AppFonts().mainFontRegular,size:15))
                    .foregroundColor(ColorPallete().mediumFGColor)
                    .accentColor(ColorPallete().accentColor)
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                    
                    .background(ColorPallete().mediumBGColor)
                    .cornerRadius(30)
                    .overlay(RoundedRectangle(cornerRadius: 30)
                                .stroke(ColorPallete().mediumFGColor)
                    )
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
                
                
                Button("Send"){
                    
                }
                .foregroundColor(ColorPallete().mediumFGColor)
                    
                        
                Spacer()
            }
            .background(ColorPallete().bgColor)
            
            
        }
        
        
    }
    
    
}

struct AllocateView_Previews: PreviewProvider {
    static var previews: some View {
        AllocateView()
    }
}
