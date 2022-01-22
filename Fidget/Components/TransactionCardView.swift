//
//  TransactionCardView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/20/22.
//

import SwiftUI

struct TransactionCardView: View {
    var transaction: String
    var body: some View {
        ZStack(){
        Rectangle()
            .frame(width: .infinity, height: 80)
            .foregroundColor(ColorPallete().mediumFGColor)
            HStack(){
                Text(transaction)
                    .font(Font.custom(AppFonts().mainFontBold, size: 20))
                    .foregroundColor(ColorPallete().mediumBGColor)
                    .padding()
                Spacer()
            }
            
            
            
        }
        
    }
}

struct TransactionCardView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionCardView(transaction: "Spent $32.21 -- at Target")
    }
}
