//
//  AddBudgetView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/8/22.
//

import SwiftUI

struct StartBudgetView: View {
    @EnvironmentObject var homeViewModel : HomeViewModel
    @Binding var showBudgetNavigationViews : Bool
    
    var body: some View {
        VStack(){
            Spacer()
            
            noBudgetAnimation
            
            Spacer()
            
            NavigationLink(destination: LinkSharedBudgetView())
            {
                StandardButton(label: "CONNECT TO SHARED BUDGET", function: {}).normalButtonLabelLarge
                    .padding(.horizontal)
            }
            
            if homeViewModel.userHasBudget {
                NavigationLink(destination: CreateBudgetView(showBudgetNavigationViews: $showBudgetNavigationViews)
                                .environmentObject(homeViewModel))
                {
                    createBudgetButtonLabel
                }
                .isDetailLink(false)
            }
            else{
                NavigationLink(destination: CreateBudgetView(showBudgetNavigationViews: $showBudgetNavigationViews)
                                .environmentObject(homeViewModel), isActive: $showBudgetNavigationViews)
                {
                    createBudgetButtonLabel
                }
            }
            Spacer()
        }
    }
    
    var noBudgetAnimation : some View {
        VStack{
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .foregroundColor(AppColor.normal)
                .frame(width: 100, height: 100)
            Text("ANIMATION PLACEHOLDER")
                .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.buttonLabelSize))
                .foregroundColor(AppColor.normal)
        }
            
    }
    
    var createBudgetButtonLabel : some View{
        VStack{
            StandardButton(label: "CREATE A BUDGET", function: {}).primaryButtonLabelLarge
                .padding(.horizontal)
        }
    }
}

/*

struct AddBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        AddBudgetView(showCreateBudgetNavigation: .constant(false))
    }
}

*/
