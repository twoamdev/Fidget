//
//  ManageBudgetsView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/27/22.
//

import SwiftUI

struct ManageBudgetsView: View {
    @EnvironmentObject var homeVM : HomeViewModel
    @EnvironmentObject var manageVM : ManageBudgetsViewModel
    @EnvironmentObject var editBudgetVM : EditBudgetViewModel
    
    
    @State var showShareBudgetPage = false
    @State var showInvitesPage = false
    @State var showEditBudgetPage = false
    @State private var showConfirmation = false
    @State private var showNeedUsernameAlert = false
    @State private var acceptWasPressed = false
    @State private var sharePacket = ShareBudgetViewPacket()
    
    @State private var showCreateBudget = false
    
    
    var body: some View {
        ZStack{
            AppColor.bg
                .transition(.moveInTrailingMoveOutTrailing)
                .onTapGesture {
                    self.manageVM.noBudgetsAreSelected()
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
                    
                    if self.manageVM.isAnOtherBudgetSelected() || self.manageVM.currentBudgetIsSelected{
                        StandardButton(label: "EDIT", wrapLabel: "CREATE", function: {
                            UXUtils.hapticButtonPress()
                            self.showEditBudgetPage = true
                        }).primaryButtonShrinkWrap
                            .fullScreenCover(isPresented: $showEditBudgetPage, onDismiss: {
                                self.manageVM.noBudgetsAreSelected()
                            }, content: {
                                EditBudgetView(show: $showEditBudgetPage)
                                    .environmentObject(homeVM)
                                    .environmentObject(editBudgetVM)
                            })
                    }
                    else{
                        
                        StandardButton(lockedStyle: self.homeVM.swapBudgetLoading ,label: "NEW", wrapLabel: "CREATE", function: {
                            UXUtils.hapticButtonPress()
                            self.showCreateBudget.toggle()
                        }).normalButtonShrinkWrap
                            .disabled(self.homeVM.swapBudgetLoading)
                            .fullScreenCover(isPresented: $showCreateBudget, onDismiss: {
                                self.homeVM.refreshOtherBudgets()
                            }, content: {
                                ZStack{
                                    
                                    VStack{
                                        NavigationView{
                                            CreateIncomeView(showBudgetNavigationViews: $showCreateBudget)
                                                .environmentObject(homeVM)
                                        }
                                    }
                                    VStack{
                                        HStack{
                                            Spacer()
                                            Button(action: {
                                                UXUtils.hapticButtonPress()
                                                self.showCreateBudget.toggle()
                                            }, label: {
                                                Image(systemName: "xmark.circle.fill")
                                                    .resizable()
                                                    .foregroundColor(AppColor.normalMoreContrast)
                                                    .frame(width: 35  , height: 35)
                                                    
                                            })
                                        }
                                        .padding()
                                        Spacer()
                                    }
                                }
                            })
                    }
                    
                    
                }
                .padding(.horizontal)
                
                if self.homeVM.swapBudgetLoading{
                    Spacer()
                    VStack{
                        ProgressView()
                    }
                }
                else{
                    displayAllBudgets
                }
                
                
                Spacer()
                
                HStack{
                    let share = manageVM.shareBudgetIsValid()
                    let set = manageVM.setToCurrentBudgetIsValid()
                    StandardButton(lockedStyle: !share, label: "SHARE BUDGET", function: {
                        UXUtils.hapticButtonPress()
                        if !homeVM.userProfile.sharedInfo.username.isEmpty{
                            if self.manageVM.currentBudgetIsSelected {
                                self.sharePacket.name = homeVM.budget.name
                                self.sharePacket.bucketCount = homeVM.budget.buckets.count
                                self.sharePacket.userCount = homeVM.budget.linkedUserIds.count
                                self.sharePacket.incomeAmount = homeVM.getBudgetIncomeAmount(homeVM.budget)
                                self.sharePacket.budgetRefId = homeVM.userProfile.privateInfo.budgetLinker.getSelectedRefId()
                            }
                            else {
                                let index = manageVM.getOtherSelectedBudgetIndex()
                                let linkedBudgetsInUserProfile = homeVM.userProfile.privateInfo.budgetLinker.referenceIds.count
                                let inRange = (index+1) <= (linkedBudgetsInUserProfile - 1)
                                if index >= 0 && inRange {
                                    self.sharePacket.name = homeVM.otherUserBudgets[index].name
                                    self.sharePacket.bucketCount = homeVM.otherUserBudgets[index].buckets.count
                                    self.sharePacket.userCount = homeVM.otherUserBudgets[index].linkedUserIds.count
                                    self.sharePacket.incomeAmount = homeVM.getBudgetIncomeAmount(homeVM.otherUserBudgets[index])
                                    self.sharePacket.budgetRefId = homeVM.userProfile.privateInfo.budgetLinker.referenceIds[index+1]
                                }
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
                        self.homeVM.swapBudgetLoading = true
                        
                        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                            let index = manageVM.getOtherSelectedBudgetIndex()
                            let selectedRefId = homeVM.userProfile.privateInfo.budgetLinker.referenceIds[index+1]
                            homeVM.setToCurrentBudget(index, selectedRefId)
                            timer.invalidate()
                        }
                        
                    }).normalButtonLarge
                        .disabled(!set)
                }
                .padding()
            }
        }
    }
    
    var displayAllBudgets : some View {
        VStack{
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
                        if manageVM.currentBudgetIsSelected{
                            BudgetCardView(budgetName: homeVM.budget.name,
                                           bucketCount: homeVM.budget.buckets.count,
                                           sharedUserCount: homeVM.budget.linkedUserIds.count,
                                           incomeAmount: homeVM.getBudgetIncomeAmount(homeVM.budget),
                                           selected: true)
                                .onTapGesture(perform: {
                                    self.manageVM.deselectAllOtherBudgets()
                                    self.manageVM.currentBudgetIsSelected.toggle()
                                    self.editBudgetVM.updateEditParameters(homeVM.budget, isCurrentBudget: true)
                                })
                        }
                        else{
                            BudgetCardView(budgetName: homeVM.budget.name,
                                           bucketCount: homeVM.budget.buckets.count,
                                           sharedUserCount: homeVM.budget.linkedUserIds.count,
                                           incomeAmount: homeVM.getBudgetIncomeAmount(homeVM.budget),
                                           selected: false)
                                .onTapGesture(perform: {
                                    self.manageVM.deselectAllOtherBudgets()
                                    self.manageVM.currentBudgetIsSelected.toggle()
                                    self.editBudgetVM.updateEditParameters(homeVM.budget, isCurrentBudget: true)
                                })
                        }
                    }
                    
                }
                .padding()
            }
            
            
            if homeVM.userHasBudget{
                let hasOtherBudgets = self.homeVM.otherUserBudgets.count > .zero
                VStack(alignment: .leading, spacing: 3.0){
                    if hasOtherBudgets{
                        Text("Other Budgets")
                            .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                            .foregroundColor(AppColor.normalMoreContrast)
                            .padding(.horizontal)
                    }
                    else{
                        HStack{
                            Text("Other Budgets")
                                .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                                .foregroundColor(AppColor.normalMoreContrast)
                            Spacer()
                            
                        }
                        .padding(.horizontal)
                    }
                    
                    if hasOtherBudgets{
                        
                        List{
                            //let count : Int = manageVM.otherBudgetIsSelected.count
                            
                            let count : Int = homeVM.otherUserBudgets.count
                            
                            ForEach(0..<count, id: \.self) { i in
                                let selected : Bool = manageVM.otherBudgetSelectionIndex == i ? true : false
                                if selected{
                                    BudgetCardView(budgetName: homeVM.otherUserBudgets[i].name,
                                                   bucketCount: homeVM.otherUserBudgets[i].buckets.count,
                                                   sharedUserCount: homeVM.otherUserBudgets[i].linkedUserIds.count,
                                                   incomeAmount: homeVM.getBudgetIncomeAmount(homeVM.otherUserBudgets[i]),
                                                   selected: true)
                                        .padding(.leading)
                                        .onTapGesture {
                                            self.manageVM.currentBudgetIsSelected = false
                                            self.manageVM.toggleOtherBudgetSelections(i)
                                            self.editBudgetVM.updateEditParameters(homeVM.otherUserBudgets[i], otherBudgetIndex: i)
                                        }
                                        .listRowSeparator(.hidden)
                                }
                                else{
                                    BudgetCardView(budgetName: homeVM.otherUserBudgets[i].name,
                                                   bucketCount: homeVM.otherUserBudgets[i].buckets.count,
                                                   sharedUserCount: homeVM.otherUserBudgets[i].linkedUserIds.count,
                                                   incomeAmount: homeVM.getBudgetIncomeAmount(homeVM.otherUserBudgets[i]),
                                                   selected: false)
                                        .padding(.leading)
                                        .onTapGesture {
                                            self.manageVM.currentBudgetIsSelected = false
                                            self.manageVM.toggleOtherBudgetSelections(i)
                                            self.editBudgetVM.updateEditParameters(homeVM.otherUserBudgets[i], otherBudgetIndex: i)
                                            
                                        }
                                        .listRowSeparator(.hidden)
                                }
                            }
                            
                            
                        }
                        .listStyle(.plain)
                        
                        
                        
                        
                    }
                }
            }
        }
    }
}

