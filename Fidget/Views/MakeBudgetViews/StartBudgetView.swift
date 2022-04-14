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
    @Binding var showInvitesPage : Bool
    
    @State var acceptPressed : Bool = false
    
    var body: some View {
        VStack(){
            Spacer()
            
            noBudgetAnimation
            
            Spacer()
            
            //show: $showInvitesPage, acceptWasPressed : $acceptWasPressed
            HStack{
                /*
                NavigationLink(destination: InvitationView(
                                 show: $showInvitesPage,
                                 acceptWasPressed: $acceptPressed)
                                .environmentObject(homeViewModel))
                {
                    StandardButton(label: "INVITATION", function: {}).normalButtonLabelLarge
                      
                }
                .navigationBarTitle("" , displayMode: .inline)
                 */
                
                let noInvitesExist = homeViewModel.invitations.isEmpty
                ZStack{
                    StandardButton(lockedStyle: noInvitesExist, label: "INVITATION", function: {
                        UXUtils.hapticButtonPress()
                        showInvitesPage.toggle()
                    }).normalButtonLarge
                        .disabled(noInvitesExist)
                        .sheet(isPresented: $showInvitesPage, onDismiss: {
                            if acceptPressed {
                                homeViewModel.refreshOtherBudgets()
                                self.acceptPressed = false
                            }
                        }, content: {
                            InvitationView(show: $showInvitesPage, acceptWasPressed : $acceptPressed)
                                .environmentObject(homeViewModel)
                        })
                }
                
                
                if homeViewModel.userHasBudget {
                    NavigationLink(destination: CreateIncomeView(showBudgetNavigationViews: $showBudgetNavigationViews)
                                    .environmentObject(homeViewModel))
                    {
                        createBudgetButtonLabel
                    }
                    .isDetailLink(false)
                    .navigationBarTitle("" , displayMode: .inline)
                    
                }
                else{
                    NavigationLink(destination: CreateIncomeView(showBudgetNavigationViews: $showBudgetNavigationViews)
                                    .environmentObject(homeViewModel), isActive: $showBudgetNavigationViews)
                    {
                        createBudgetButtonLabel
                    }
                    .navigationBarTitle("" , displayMode: .inline)
                    
                }
                
            }
            .padding()
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
            StandardButton(label: "CREATE", function: {}).primaryButtonLabelLarge
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
