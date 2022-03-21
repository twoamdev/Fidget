//
//  CloseAccountView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/12/22.
//

import SwiftUI

struct DeleteAccountView: View {
    @EnvironmentObject var homeVM : HomeViewModel
    @EnvironmentObject var transactionVM : TransactionViewModel
    @EnvironmentObject var signInVM : SignInViewModel
    @EnvironmentObject var signUpVM : SignUpViewModel
    @Binding var showDeleteView : Bool
    @State var deleteVM = DeleteAccountViewModel()
    @State var selection : Int = .zero
    
    var body: some View {
        VStack{
            HStack{
            Text("Delete Account")
                .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                .kerning(AppFonts.titleKerning)
                Spacer()
            }
            .padding()
            
            Spacer()
            userFeedBack
            deleteButton
            
        }
    }
    
    var userFeedBack : some View {
        VStack{
            let nonSelectedIcon = "circle"
            let selectedIcon = "circle.fill"
            let nonSelectedColor = AppColor.normalFocused
            List{
                StandardLabel(labelText: "It's not easy to use", labelIconName: self.selection == 1 ? selectedIcon : nonSelectedIcon, customColor: self.selection == 1 ? nil : nonSelectedColor)
                    .padding(.vertical)
                    .onTapGesture {
                        self.selection = 1
                    }
                StandardLabel(labelText: "I just lost interest using it", labelIconName: self.selection == 2 ? selectedIcon : nonSelectedIcon, customColor: self.selection == 2 ? nil : nonSelectedColor)
                    .padding(.vertical)
                    .onTapGesture {
                        self.selection = 2
                    }
                StandardLabel(labelText: "I wish there were more features", labelIconName: self.selection == 3 ? selectedIcon : nonSelectedIcon, customColor: self.selection == 3 ? nil : nonSelectedColor)
                    .padding(.vertical)
                    .onTapGesture {
                        self.selection = 3
                    }
                StandardLabel(labelText: "Other", labelIconName: self.selection == 4 ? selectedIcon : nonSelectedIcon, customColor: self.selection == 4 ? nil : nonSelectedColor)
                    .padding(.vertical)
                    .onTapGesture {
                        self.selection = 4
                    }
            }
            .listStyle(.plain)
        }
    }
    
    var deleteButton : some View {
        VStack{
            StandardButton(label: "DELETE ACCOUNT", function: {
                //Delete
                deleteVM.deleteUserAccount(homeVM, transactionVM)
    
                //Back to main screen
                self.showDeleteView = false
                signInVM.showHome = false
                signUpVM.showHome = false
                
            }).primaryButtonLarge
                .padding(.horizontal)
                .disabled(self.selection == .zero)
            Text("There's no going back after you press delete.")
                .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                .foregroundColor(self.selection == .zero ? AppColor.normal : AppColor.normalFocused)
        }
        .padding()
    }
}

struct CloseAccountView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteAccountView(showDeleteView: .constant(true))
    }
}
