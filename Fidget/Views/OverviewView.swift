//
//  OverviewView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct OverviewView: View {
    @EnvironmentObject var homeViewModel : HomeViewModel
    
    var body: some View {
     VStack {
        Text("OVERVIEW VIEW")
         Button(action: {
             homeViewModel.renewBudget()
         }, label: {
             Text("Test Reset Budget")
         })
        }
    }
}

struct OverviewView_Previews: PreviewProvider {
    static var previews: some View {
        OverviewView()
    }
}
