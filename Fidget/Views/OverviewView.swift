//
//  OverviewView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct OverviewView: View {
    @EnvironmentObject var homeViewModel : HomeViewModel
    @EnvironmentObject var transactionViewModel : TransactionViewModel
    
    var body: some View {
        VStack {
            Text("No Overview Available Yet.")
                .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.inputFieldSize))
        }
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView()
    }
}
