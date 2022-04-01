//
//  ShareBudgetView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/27/22.
//

import SwiftUI

struct ShareBudgetView: View {
    @EnvironmentObject var homeVM : HomeViewModel
    @ObservedObject var shareBudgetVM : ShareBudgetViewModel = ShareBudgetViewModel()
    @Binding var show : Bool
    @Binding var sharePacket : ShareBudgetViewPacket
    
    @State private var rawUsername = String()
    @State private var username = String()

    @State private var showSendSuccess = false
    @State private var alertText = String()
    @State private var alertMessage = String()
    
    var body: some View {
        ZStack{
            AppColor.bg
                .transition(.moveInTrailingMoveOutTrailing)
                .onTapGesture {
                    self.dismissFocusOnAll()
                }
            VStack{
                HStack{
                    Text("Share a budget")
                        .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                        .kerning(AppFonts.titleKerning)
                    
                    Spacer()
                    
                }
                .padding()
                
                VStack(alignment: .leading, spacing: 3.0){
                    Text("Budget to share")
                        .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                        .foregroundColor(AppColor.normalMoreContrast)
                    
                    BudgetCardView(budgetName: sharePacket.name, bucketCount: sharePacket.bucketCount, sharedUserCount: sharePacket.userCount, incomeAmount: sharePacket.incomeAmount, selected: .constant(true))
                    
                }
                .padding(.horizontal)
                .padding(.bottom)
                
                
                
                VStack(alignment: .leading, spacing: 3.0){
                    Text("Share budget with:")
                        .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                        .foregroundColor(AppColor.normalMoreContrast)
                    StandardTextField(label: "Username", text: $username)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .onChange(of: username, perform: { value in
                            (username, rawUsername) = FormatUtils.usernameFormat(value)
                        })
                    
                }
                .padding(.horizontal)
                Spacer()
                Spacer()
                
                VStack{
                    if rawUsername.isEmpty{
                        StandardButton(lockedStyle: true, label: "SEND INVITE", function: {}).normalButtonLabelLarge
                    }
                    else{
                    StandardButton(label: "SEND INVITE", function: {
                        UXUtils.hapticButtonPress()
                        let refId = sharePacket.budgetRefId
                        shareBudgetVM.validateUsername(rawUsername, homeVM.userProfile.sharedInfo.username, refId)
                        
                    }).primaryButtonLarge
                            .alert(isPresented: $shareBudgetVM.showAlert) {
                            Alert(
                                title: Text(shareBudgetVM.alertText),
                                message: Text(shareBudgetVM.alertMessage),
                                dismissButton: .default(Text("OK")){
                                    if shareBudgetVM.usernameSuccess {
                                        show.toggle()
                                    }
                                }
                            )
                        }
                    }
                    StandardButton(label: "DONE", function: {
                        show.toggle()
                    }).normalButtonLarge
                }
                .padding()
            }
        }
    }
}

struct ShareBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        ShareBudgetView(show: .constant(false), sharePacket: .constant(ShareBudgetViewPacket()))
    }
}

struct ShareBudgetViewPacket {
    var name : String
    var bucketCount : Int
    var userCount : Int
    var incomeAmount : String
    var budgetRefId : String
    
    init(_ name : String, _ bucketCount : Int, _ userCount : Int, _ incomeAmount : String, _ budgetRefId : String){
        self.name = name
        self.bucketCount = bucketCount
        self.userCount = userCount
        self.incomeAmount = incomeAmount
        self.budgetRefId = budgetRefId
    }
    
    init(){
        self.name = String()
        self.bucketCount = .zero
        self.userCount = .zero
        self.incomeAmount = String()
        self.budgetRefId = String()
    }
}
