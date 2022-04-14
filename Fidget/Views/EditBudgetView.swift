//
//  EditBudgetView.swift
//  Fidget
//
//  Created by Ben Nelson on 4/4/22.
//

import SwiftUI

struct EditBudgetView: View {
    @EnvironmentObject var homeVM : HomeViewModel
    @EnvironmentObject var editVM : EditBudgetViewModel
    @Binding var show : Bool
    @State private var showAddIncomeView : Bool = false
    @State private var showDeleteBudgetConfirmation : Bool = false
    
    @State var changeOccured = false
    
    var body: some View {
        VStack{
            VStack{
                HStack{
                    Spacer()
                    trashButton
                    
                }
                .padding()
                HStack{
                    VStack(alignment: .leading, spacing: 0){
                        Text("Budget Name")
                            .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                            .foregroundColor(AppColor.normalMoreContrast)
                        TextField("Name", text: $editVM.budgetName)
                            .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                            .foregroundColor(AppColor.fg)
                            .accentColor(AppColor.primary)
                            .onChange(of: editVM.budgetName, perform: { value in
                                self.changeOccured = true
                                
                                if value.count > FormatUtils.maxBudgetNameLimit{
                                    editVM.budgetName = String(value.prefix(FormatUtils.maxBudgetNameLimit))
                                }
                                
                                let isValid = ValidationUtils().validateNameWithWhiteSpaces(value) || value.isEmpty
                                if !isValid {
                                    let limit = FormatUtils.maxBudgetNameLimit-1 > 0 ? FormatUtils.maxBudgetNameLimit-1 : 0
                                    editVM.budgetName = String(value.prefix(limit))
                                }
                               
                            })
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(AppColor.fg)
                            .padding(.trailing, 16)
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
            
            Spacer()
            VStack(alignment: .leading, spacing: 0){
                HStack{
                    Text("Sources of Income")
                        .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                        .foregroundColor(AppColor.normalMoreContrast)
                    Spacer()
                    StandardButton(label: "ADD INCOME", function: {
                        UXUtils.hapticButtonPress()
                        self.changeOccured = true
                        showAddIncomeView.toggle()
                    }).normalButtonShrinkWrap
                        .sheet(isPresented: $showAddIncomeView) {
                            AddIncomeView(showAddIncomeView: $showAddIncomeView , incomeItems: $editVM.incomeItems)
                        }
                    
                }
                .padding()
                
                editIncomeItems
            }
            
            
            Spacer()
            VStack{
                
                
                HStack{
                    StandardButton(label: "CANCEL", function: {
                        UXUtils.hapticButtonPress()
                        self.show = false
                    }).normalButtonLarge
                    
                    StandardButton(lockedStyle: !changeOccured, label: "SAVE CHANGES", function: {
                        UXUtils.hapticButtonPress()
                        self.homeVM.swapBudgetLoading = true
                        self.homeVM.saveChangesToBudget(self.editVM.budgetName, self.editVM.incomeItems, self.editVM.editIsOtherBudget())
                        self.show = false
                    }).primaryButtonLarge
                        .disabled(!changeOccured)
                    
                }
                .padding()
            }
        }
    }
    
    var trashButton : some View {
        Button(action: {
            UXUtils.hapticButtonPress()
            self.showDeleteBudgetConfirmation.toggle()
        }, label: {
            Image(systemName: editVM.isPrivate ? "trash.circle.fill" : "person.crop.circle.fill.badge.xmark")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(AppColor.normalMoreContrast)
                .frame(width: AppFonts.titleFieldSize, height: AppFonts.titleFieldSize)
        })
            .confirmationDialog( editVM.isPrivate ? "Delete Budget" : "Unfollow Budget", isPresented: $showDeleteBudgetConfirmation){
                StandardButton(label: "Yes", function: {
                    //homeVM.unfollowBudget(editVM.)
                    self.show = false
                    self.homeVM.swapBudgetLoading = true
                    
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
                        
                        if editVM.editIsCurrentBudget(){
                            if editVM.isPrivate {
                                print("deleting CURRENT budget")
                                homeVM.detachFromBudget(deleteBudget : true, isCurrentBudget : true)
                            }
                            else{
                                print("unfollowing CURRENT budget")
                                homeVM.detachFromBudget(unfollowBudget : true, isCurrentBudget : true)
                            }
                        }
                        else{
                            let (isOther, otherIndex) = editVM.editIsOtherBudget()
                            if isOther{
                                if editVM.isPrivate {
                                    print("deleting OTHER budget at index: \(otherIndex)")
                                    homeVM.detachFromBudget(deleteBudget : true, otherBudgetIndex : otherIndex)
                                }
                                else{
                                    print("unfollowing OTHER budget at index: \(otherIndex)")
                                    homeVM.detachFromBudget(unfollowBudget : true, otherBudgetIndex : otherIndex)
                                }
                            }
                        }
                        timer.invalidate()
                    }
                    
                })
            } message : {
                let privateText = "Are you sure you want to delete the entire budget? This cannot be undone."
                let sharedText = "Are you sure you want to stop sharing with this budget? You'd need an invite from another user to contribute again."
                let message = editVM.isPrivate ? privateText : sharedText
                Text(message)
            }
    }
    
    
    
    var editIncomeItems : some View {
        VStack{
            List{
                ForEach(0..<editVM.incomeItems.count, id: \.self) { i in
                    IncomeItemMiniView(incomeItem: $editVM.incomeItems[i],
                                       onDelete: {
                        deleteItem(at: IndexSet(integer: i))
                        self.changeOccured = true
                    })
                        .padding(.vertical)
                    
                }
            }
            .listStyle(.plain)
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        self.editVM.incomeItems.remove(atOffsets: offsets)
        print("income items: \(self.editVM.incomeItems)")
    }
    
    
}

/*
 struct EditBudgetView_Previews: PreviewProvider {
 static var previews: some View {
 EditBudgetView(.con)
 }
 }
 
 */
