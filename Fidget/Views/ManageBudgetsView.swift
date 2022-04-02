//
//  ManageBudgetsView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/27/22.
//

import SwiftUI

struct ManageBudgetsView: View {
    @EnvironmentObject var homeVM : HomeViewModel
    @State var selectedIndex : Int = -1
    @State var selections = [false, false, false, false, false]
    @State var isSelected = false
    @State var currentBudgetSelected = false
    //@State var invitesExist = true
    
    @State var showShareBudgetPage = false
    @State var showInvitesPage = false
    @State private var showConfirmation = false
    @State private var showNeedUsernameAlert = false
    @State private var acceptWasPressed = false
    
    
    @State private var sharePacket = ShareBudgetViewPacket()
    
    
    var body: some View {
        ZStack{
            AppColor.bg
                .transition(.moveInTrailingMoveOutTrailing)
                .onTapGesture {
                    self.currentBudgetSelected = false
                    self.isSelected = false
                    self.selectedIndex = -1
                    for j in 0..<selections.count{
                        selections[j] = false
                    }
                }
            VStack{
                
                HStack{
                    Text("Budgets")
                        .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                        .kerning(AppFonts.titleKerning)
                    Spacer()
                    
                    let noInvitesExist = homeVM.invitations.isEmpty
                    ZStack{
                        StandardButton(lockedStyle: noInvitesExist, label: "INVITES", function: {
                            UXUtils.hapticButtonPress()
                            showInvitesPage.toggle()
                        }).normalButtonShrinkWrap
                            .disabled(noInvitesExist)
                            .sheet(isPresented: $showInvitesPage, onDismiss: {
                                if acceptWasPressed {
                                    homeVM.refreshOtherBudgets()
                                    self.acceptWasPressed = false
                                }
                            }, content: {
                                InvitationView(show: $showInvitesPage, acceptWasPressed : $acceptWasPressed)
                                    .environmentObject(homeVM)
                            })
                        if(!noInvitesExist){
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(AppColor.alert)
                                .offset(x: 38, y: -18)
                        }
                    }
                    
                    StandardButton(label: "CREATE", function: {
                        UXUtils.hapticButtonPress()
                    }).normalButtonShrinkWrap
                    
                    /*
                     StandardButton(lockedStyle: !self.isSelected, label: "DELETE", function: {
                     UXUtils.hapticButtonPress()
                     showConfirmation.toggle()
                     }).normalButtonShrinkWrap
                     .disabled(!self.isSelected)
                     .confirmationDialog("Delete Budget", isPresented: $showConfirmation){
                     StandardButton(label: "Yes", function: {
                     print("delete")
                     })
                     } message : {
                     Text("Are you sure you want to delete this budget?")
                     }
                     */
                    
                    
                    
                }
                .padding(.horizontal)
                
                
                if !homeVM.userHasBudget {
                    
                    Text("No Budget Yet.")
                        .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.inputFieldSize))
                        .padding()
                        .padding()
                    
                }
                else{
                    
                    VStack(alignment: .leading, spacing: 3.0){
                        
                        
                        Text("Current Budget")
                            .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                            .foregroundColor(AppColor.normalMoreContrast)
                        ZStack{
                            BudgetCardView(budgetName: homeVM.budget.name,
                                           bucketCount: homeVM.budget.buckets.count,
                                           sharedUserCount: homeVM.budget.linkedUserIds.count,
                                           incomeAmount: homeVM.getBudgetIncomeAmount(homeVM.budget),
                                           selected: $currentBudgetSelected)
                                .onTapGesture(perform: {
                                    self.currentBudgetSelected.toggle()
                                    /*
                                     self.selectedIndex = -1
                                     for j in 0..<selections.count{
                                     selections[j] = false
                                     }
                                     */
                                    self.isSelected = self.currentBudgetSelected
                                    
                                })
                            if(self.currentBudgetSelected){
                                ZStack{
                                    Image(systemName: "circle.fill")
                                        .resizable()
                                        .foregroundColor(AppColor.bg)
                                        .frame(width:25, height: 25)
                                        .offset(x: 170, y: -38)
                                    Image(systemName: "xmark.circle.fill")
                                        .resizable()
                                        .foregroundColor(AppColor.normalMoreContrast)
                                        .frame(width:25, height: 25)
                                        .offset(x: 170, y: -38)
                                        .onTapGesture {
                                            print("delete me bitch")
                                            UXUtils.hapticButtonPress()
                                            showConfirmation.toggle()
                                        }
                                        .confirmationDialog("Delete Budget", isPresented: $showConfirmation){
                                            StandardButton(label: "Yes", function: {
                                                print("delete")
                                            })
                                        } message : {
                                            Text("Are you sure you want to delete this budget?")
                                        }
                                }
                            }
                        }
                    }
                    .padding()
                }
                
                
                if homeVM.userHasBudget{
                    VStack(alignment: .leading, spacing: 3.0){
                        Text("Other Budgets")
                            .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                            .foregroundColor(AppColor.normalMoreContrast)
                            .padding(.horizontal)
                        
                        
                        List{
                            let count : Int = homeVM.otherUserBudgets.count
        
                            ForEach(0..<count, id: \.self) { i in
                                
                                
                                BudgetCardView(budgetName: homeVM.otherUserBudgets[i].name,
                                               bucketCount: homeVM.otherUserBudgets[i].buckets.count,
                                               sharedUserCount: homeVM.otherUserBudgets[i].linkedUserIds.count,
                                               incomeAmount: homeVM.getBudgetIncomeAmount(homeVM.otherUserBudgets[i]),
                                               selected: $selections[i])
                                 .padding(.leading)
                                 .onTapGesture {
                                 self.selectedIndex = i
                                 for j in 0..<selections.count{
                                 selections[j] = i == j ? true : false
                                 }
                                 self.isSelected = true
                                 self.currentBudgetSelected = false
                                 }
                                 .listRowSeparator(.hidden)
                            }
                        }.listStyle(.plain)
                    }
                }
                
                Spacer()
                
                HStack{
                    let share = self.selectedIndex != -1 || self.currentBudgetSelected
                    let set = self.selectedIndex != -1 && !self.currentBudgetSelected
                    StandardButton(lockedStyle: !share, label: "SHARE BUDGET", function: {
                        UXUtils.hapticButtonPress()
                        if !homeVM.userProfile.sharedInfo.username.isEmpty{
                            if self.currentBudgetSelected {
                                self.sharePacket.name = homeVM.budget.name
                                self.sharePacket.bucketCount = homeVM.budget.buckets.count
                                self.sharePacket.userCount = homeVM.budget.linkedUserIds.count
                                self.sharePacket.incomeAmount = homeVM.getBudgetIncomeAmount(homeVM.budget)
                                self.sharePacket.budgetRefId = homeVM.userProfile.privateInfo.budgetLinker.getSelectedRefId()
                                print("Share packet:\n\(self.sharePacket)")
                            }
                            showShareBudgetPage.toggle()
                        }
                        else{
                            showNeedUsernameAlert.toggle()
                        }
                    }).normalButtonLarge
                        .disabled(!share)
                        .sheet(isPresented: $showShareBudgetPage, onDismiss: {}, content: {
                            ShareBudgetView(show: $showShareBudgetPage, sharePacket: $sharePacket)
                                .environmentObject(homeVM)
                        })
                        .alert(isPresented: $showNeedUsernameAlert) {
                            Alert(
                                title: Text("Username required."),
                                message: Text("Create a username to share budgets. Go to \"Personal Info -> Change Username\" to create one."),
                                dismissButton: .default(Text("OK")){
                                    //showNeedUsernameAlert.toggle()
                                }
                            )
                        }
                    
                    
                    StandardButton(lockedStyle: !set ,label: "SET AS CURRENT", function: {
                        UXUtils.hapticButtonPress()
                    }).normalButtonLarge
                        .disabled(!set)
                }
                .padding()
            }
        }
    }
}

