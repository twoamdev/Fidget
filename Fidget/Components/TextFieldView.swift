//
//  TextFieldView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/23/22.
//

import SwiftUI

struct TextFieldView: View {
    @State var label : String
    @Binding var userInput : String
    private let fontSize = 15.0
    private let cornerRadiusAmt = 5.0
    private let textPadding = EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
    private let boxPadding = EdgeInsets(top: 0, leading: 30, bottom: 5, trailing: 30)
    
    var body: some View{
        VStack(){
            Text("Main")
        }
    }
    
    var standardTextField: some View{
        VStack(){
            TextField(label, text: $userInput)
                .font(Font.custom(AppFonts().mainFontBold,size:fontSize))
                .foregroundColor(ColorPallete().mediumBGColor)
                .accentColor(ColorPallete().accentColor)
                .padding(textPadding)
                .background(ColorPallete().lightFGColor)
                .cornerRadius(cornerRadiusAmt)
                .overlay(RoundedRectangle(cornerRadius: cornerRadiusAmt)
                            .stroke(ColorPallete().mediumFGColor)
                )
                .padding(boxPadding)
        }
    }
    
    var secureTextField: some View{
        VStack(){
            SecureField(label, text: $userInput)
                .font(Font.custom(AppFonts().mainFontBold,size:fontSize))
                .foregroundColor(ColorPallete().mediumBGColor)
                .accentColor(ColorPallete().accentColor)
                .padding(textPadding)
                .background(ColorPallete().lightFGColor)
                .cornerRadius(cornerRadiusAmt)
                .overlay(RoundedRectangle(cornerRadius: cornerRadiusAmt)
                            .stroke(ColorPallete().mediumFGColor)
                )
                .padding(boxPadding)
        }
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView(label: "my label", userInput: .constant("")).standardTextField
    }
}
