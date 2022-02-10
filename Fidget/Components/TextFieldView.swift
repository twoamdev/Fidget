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
    @State var errorMessage : String
    private let fontSize = 15.0
    private let cornerRadiusAmt = 5.0
    private let textPadding = EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)
    private let boxPadding = EdgeInsets(top: 0, leading: 30, bottom: 5, trailing: 30)
    @State var fgColor = ColorPallete().mediumBGColor
    @State var bgColor = ColorPallete().lightFGColor
    @State var strokeColor = ColorPallete().mediumFGColor
    @State var errorColor = Color.red
    
    
    var body: some View{
        VStack(){
            Text("Main")
        }
    }
    
    var standardTextField: some View{
        VStack(){
            TextField(label, text: $userInput)
                .font(Font.custom(AppFonts().mainFontBold,size:fontSize))
                .foregroundColor(fgColor)
                .accentColor(ColorPallete().accentColor)
                .padding(textPadding)
                .background(bgColor)
                .cornerRadius(cornerRadiusAmt)
                .overlay(RoundedRectangle(cornerRadius: cornerRadiusAmt)
                            .stroke(errorMessage == "" ? strokeColor: errorColor)
                )
                //.padding(boxPadding)
            
            if errorMessage != ""{
                Text(errorMessage)
                    .foregroundColor(errorColor)
                    .font(Font.custom(AppFonts().mainFontBold,size:fontSize*0.9))
                    .padding(.horizontal)
            }
             
        
            
        }
    }
    
    var standardTextFieldNumberFormatter: some View{
        VStack(){
            TextField(label, value: $userInput, formatter: NumberFormatter())
                .font(Font.custom(AppFonts().mainFontBold,size:fontSize))
                .foregroundColor(fgColor)
                .accentColor(ColorPallete().accentColor)
                .padding(textPadding)
                .background(bgColor)
                .cornerRadius(cornerRadiusAmt)
                .overlay(RoundedRectangle(cornerRadius: cornerRadiusAmt)
                            .stroke(errorMessage == "" ? strokeColor: errorColor)
                )
                //.padding(boxPadding)
            
            if errorMessage != ""{
                Text(errorMessage)
                    .foregroundColor(errorColor)
                    .font(Font.custom(AppFonts().mainFontBold,size:fontSize*0.9))
                    .padding(.horizontal)
            }
             
        
            
        }
    }
    
    
    
    var secureTextField: some View{
        VStack(){
            SecureField(label, text: $userInput)
                .font(Font.custom(AppFonts().mainFontBold,size:fontSize))
                .foregroundColor(fgColor)
                .accentColor(ColorPallete().accentColor)
                .padding(textPadding)
                .background(bgColor)
                .cornerRadius(cornerRadiusAmt)
                .overlay(RoundedRectangle(cornerRadius: cornerRadiusAmt)
                            .stroke(errorMessage == "" ? bgColor : errorColor)
                )
                //.padding(boxPadding)
            if errorMessage != ""{
                Text(errorMessage)
                    .foregroundColor(errorColor)
                    .font(Font.custom(AppFonts().mainFontBold,size:fontSize*0.9))
                    .padding(.horizontal)
            }
            
        }
    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldView(label: "my label", userInput: .constant(""), errorMessage: "").standardTextField
    }
}
