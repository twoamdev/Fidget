//
//  ShareBudgetView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/27/22.
//

import SwiftUI

struct ShareBudgetView: View {
    @Binding var show : Bool
    @State private var username = String()
    @State private var showAlert = false
    @State private var showSendSuccess = false
    @State private var alertText = String()
    @State private var alertMessage = String()
    
    var body: some View {
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
                
                BudgetCardView(budgetName: "Nelson Family Budget", bucketCount: 200, sharedUserCount: 1, incomeAmount: "$5,204", selected: .constant(true))

            }
            .padding(.horizontal)
            .padding(.bottom)
            
            
            
            VStack(alignment: .leading, spacing: 3.0){
                Text("Username to send invite")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(AppColor.normalMoreContrast)
                StandardTextField(label: "Username", text: $username)
                    
            }
            .padding(.horizontal)
            Spacer()
            Spacer()
            
            VStack{
                StandardButton(label: "SEND INVITE", function: {
                    UXUtils.hapticButtonPress()
                    let successText = "Budget sent."
                    let failText = "No budget was sent."
                    
                    let successMessage = "@\(username) should have your invite now."
                    let failMessage = "There is no person registered with the username you listed."
                    
                    self.showSendSuccess = username.isEmpty ? false : true
                    self.alertText = showSendSuccess ? successText : failText
                    self.alertMessage = showSendSuccess ? successMessage : failMessage
                    showAlert.toggle()
                    
                }).primaryButtonLarge
                    .alert(isPresented: $showAlert) {
                        Alert(
                            title: Text(self.alertText),
                            message: Text(self.alertMessage),
                            dismissButton: .default(Text("OK")){
                                if self.showSendSuccess {
                                    show.toggle()
                                }
                            }
                        )
                    }
                StandardButton(label: "DONE", function: {
                    show.toggle()
                }).normalButtonLarge
            }
            .padding()
        }
    }
}

struct ShareBudgetView_Previews: PreviewProvider {
    static var previews: some View {
        ShareBudgetView(show: .constant(false))
    }
}
