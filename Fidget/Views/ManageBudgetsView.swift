//
//  ManageBudgetsView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/27/22.
//

import SwiftUI

struct ManageBudgetsView: View {
    @State var selectedIndex : Int = -1
    @State var selections = [false, false, false, false, false]
    @State var isSelected = false
    @State var currentBudgetSelected = false
    @State var invitesExist = true
    
    @State var showShareBudgetPage = false
    @State var showInvitesPage = false
    @State private var showConfirmation = false
    
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
                    ZStack{
                        StandardButton(lockedStyle: !invitesExist, label: "INVITES", function: {
                            UXUtils.hapticButtonPress()
                            showInvitesPage.toggle()
                        }).normalButtonShrinkWrap
                            .disabled(!invitesExist)
                            .sheet(isPresented: $showInvitesPage, onDismiss: {}, content: {
                                InvitationView(show: $showInvitesPage)
                            })
                        if(invitesExist){
                            Image(systemName: "exclamationmark.circle.fill")
                                .foregroundColor(AppColor.alert)
                                .offset(x: 38, y: -18)
                        }
                    }
                    StandardButton(lockedStyle: !self.isSelected, label: "DELETE", function: {
                        UXUtils.hapticButtonPress()
                        showConfirmation.toggle()
                    }).primaryButtonShrinkWrap
                        .disabled(!self.isSelected)
                        .confirmationDialog("Delete Budget", isPresented: $showConfirmation){
                            StandardButton(label: "Yes", function: {
                                print("delete")
                            })
                        } message : {
                            Text("Are you sure you want to delete this budget?")
                        }
 
                        
                }
                .padding(.horizontal)
                
                
                VStack(alignment: .leading, spacing: 1.0){
                    Text("Current Budget")
                        .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                        .foregroundColor(AppColor.normalMoreContrast)
                    
                    BudgetCardView(budgetName: "Nelson Family Budget", bucketCount: 200, sharedUserCount: 1, incomeAmount: "$5,204", selected: $currentBudgetSelected)
                        .onTapGesture(perform: {
                            self.currentBudgetSelected = true
                            self.selectedIndex = -1
                            for j in 0..<selections.count{
                                selections[j] = false
                            }
                            self.isSelected = true
                            
                        })
                    
                    
                }
                .padding()
                
                
                VStack(alignment: .leading, spacing: 1.0){
                    Text("Other Budgets")
                        .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                        .foregroundColor(AppColor.normalMoreContrast)
                        .padding(.horizontal)
                    
                    
                    List{
                        let count : Int = 5
                        let names = ["Family Budget","Work Budget", "Fun Budget", "Movie Budget", "Random Budget"]
                        let bucketCounts = [45,10,5,39,20]
                        let users = [4,3,5,1,19]
                        let incomes = ["$3,000", "$5,020", "$854", "$300,000", "$3,000,999"]
                        
                        ForEach(0..<count, id: \.self) { i in
                            BudgetCardView(budgetName: names[i], bucketCount: bucketCounts[i], sharedUserCount: users[i], incomeAmount: incomes[i], selected: $selections[i])
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
                
                
                Spacer()
                
                HStack{
                    let share = self.selectedIndex != -1 || self.currentBudgetSelected
                    let set = self.selectedIndex != -1 && !self.currentBudgetSelected
                    StandardButton(lockedStyle: !share, label: "SHARE BUDGET", function: {
                        UXUtils.hapticButtonPress()
                        showShareBudgetPage.toggle()
                    }).normalButtonLarge
                        .disabled(!share)
                        .sheet(isPresented: $showShareBudgetPage, onDismiss: {}, content: {
                            ShareBudgetView(show: $showShareBudgetPage)
                        })
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

