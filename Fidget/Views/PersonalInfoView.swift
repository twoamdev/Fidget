//
//  PersonalInfoView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/12/22.
//

import SwiftUI


struct PersonalInfoView: View {
    @Binding var showProfileInfo : Bool
    @State var showEmailAlert = false
    @Binding var showChangeUsername : Bool
    @Binding var showChangeName : Bool
    @EnvironmentObject var homeVM : HomeViewModel
    @EnvironmentObject var infoVM : PersonalInfoViewModel
    @State var infoTextColor = AppColor.normalMoreContrast
    let infoTextSpacing = 1.0
    
    
    
    var body: some View {
        VStack{
            HStack{
                Text("Personal Info")
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                    .foregroundColor(AppColor.fg)
                    .kerning(AppFonts.titleKerning)
                Spacer()
            }
            .padding()
            List{
                StandardLabel(labelText: "Change Name", showNavArrow: true)
                    .padding(.vertical)
                    .onTapGesture {
                        withAnimation{
                            showChangeName.toggle()
                        }
                    }
                StandardLabel(labelText: "Change Username", showNavArrow: true)
                    .padding(.vertical)
                    .onTapGesture {
                        withAnimation{
                            showChangeUsername.toggle()
                        }
                    }
                NavigationLink(destination: emailField
                ) {
                    StandardLabel(labelText: "Change Email Address")
                        .padding(.vertical)
                }.navigationBarTitle("", displayMode: .inline)
                
            }
            .listStyle(.plain)
        }
        .navigationBarBackButtonHidden(showChangeUsername || showChangeName)
        .frame(minWidth: .zero, maxWidth: .infinity, minHeight: .zero, maxHeight: .infinity)
        .blur(radius: showChangeUsername || showChangeName ? AppStyle.bgBlurRadius : .zero)
        .overlay(showChangeUsername ? ChangeUsernameView(show: $showChangeUsername.animation())
                    .environmentObject(infoVM)
                    .environmentObject(homeVM)
                    .onAppear(perform: {infoVM.currentUsername = homeVM.userProfile.sharedInfo.username})
                    .onDisappear(perform: {infoVM.resetSharedInfoInputs()})
                 : nil)
        .overlay(showChangeName ? ChangeNameView(show: $showChangeName.animation())
                    .environmentObject(infoVM)
                    .environmentObject(homeVM)
                    .onAppear(perform: {
            let fullName = homeVM.userProfile.sharedInfo.firstName + " " + homeVM.userProfile.sharedInfo.lastName
            infoVM.currentFullName = fullName
        })
                    .onDisappear(perform: {infoVM.resetSharedInfoInputs()})
                 : nil)
        
        
        
    }
    
    
    var emailField : some View {
        VStack{
            VStack(alignment: .leading, spacing: infoTextSpacing){
                Text("Email Address")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(infoTextColor)
                StandardTextField(label: "Email Address", text: .constant("")).normal
                    .disabled(true)
                    .onTapGesture {
                        showEmailAlert.toggle()
                    }
                    .alert(isPresented: $showEmailAlert) {
                        Alert(
                            title: Text("Unable to change email address"),
                            message: Text("Currently that feature isn't " +
                                          "implented, but will be in the future.")
                        )
                    }
            }
        }
        .padding()
    }

}


