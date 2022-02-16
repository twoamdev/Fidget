//
//  NumberFieldComponent.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/15/22.
//

import SwiftUI

struct NumberFieldComponent: View {
    
    
    @State var label : String
    @Binding var bindValue : Double
    
    init(label : String, bindValue : Binding<Double>){
        self.label = label
        self._bindValue  = bindValue
        self.formatter.zeroSymbol = ""
    }
    
    var formatter = NumberFormatter()
    private let cornerRadiusAmt = 5.0
    private let strokeColor = ColorPallete().mediumFGColor
    private let textPadding = EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15)

    
    var body: some View {
        
        TextField(label, value: $bindValue , formatter: formatter)
            .font(Font.custom(AppFonts().mainFontBold,
                  size: AppFonts().inputFieldSize))
            .padding(textPadding)
            .cornerRadius(cornerRadiusAmt)
            .overlay(RoundedRectangle(cornerRadius: cornerRadiusAmt)
                    .stroke(strokeColor)
            )
            
    }
}

struct NumberFieldComponent_Previews: PreviewProvider {
    static var previews: some View {
        NumberFieldComponent(label: "Money", bindValue: .constant(90.0))
    }
}
