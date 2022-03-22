//
//  ProfileView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var homeVM : HomeViewModel
    @EnvironmentObject var transactionVM : TransactionViewModel
    @EnvironmentObject var profileViewModel : ProfileViewModel
    @EnvironmentObject var signInVM : SignInViewModel
    @EnvironmentObject var signUpVM : SignUpViewModel
    @ObservedObject var infoVM = PersonalInfoViewModel()
    @Binding var showDeleteView : Bool
    @Binding var showProfileInfo : Bool
    @Binding var showChangeUsername : Bool
    @Binding var showChangeName : Bool
    
    
    var body: some View {
        VStack{
            NavigationView{
                VStack{
                    profileBanner
                    List{
                        NavigationLink(destination:PersonalInfoView(showProfileInfo : $showProfileInfo, showChangeUsername: $showChangeUsername, showChangeName : $showChangeName)
                                        .environmentObject(homeVM)
                                        .environmentObject(infoVM) ,isActive: $showProfileInfo){
                            StandardLabel(labelText: "Personal Info", labelIconName: "person.circle")
                                .padding(.vertical)
                        }
                                        .navigationBarTitle("", displayMode: .inline)
                        
                        
                        StandardLabel(labelText: "Password + Security", labelIconName: "lock.circle")
                            .padding(.vertical)
                        StandardLabel(labelText: "Settings", labelIconName: "gear")
                            .padding(.vertical)
                        
                        NavigationLink(destination:
                                        DeleteAccountView(showDeleteView: $showDeleteView)
                                        .environmentObject(homeVM)
                                        .environmentObject(transactionVM)
                                        .environmentObject(signInVM)
                                        .environmentObject(signUpVM),
                                       isActive: $showDeleteView
                        ) {
                            StandardLabel(labelText: "Delete Account", labelIconName: "trash.circle")
                                .padding(.vertical)
                        }
                        .navigationBarTitle("", displayMode: .inline)
                        /*
                         StandardLabel(labelText: "FAQS", labelIconName: "info.circle")
                         .padding(.vertical)
                         StandardLabel(labelText: "Terms & Conditions", labelIconName: "doc.circle")
                         .padding(.vertical)
                         
                         StandardLabel(labelText: "Support Center", labelIconName: "questionmark.circle")
                         .padding(.vertical)
                         */
                    }
                    .listStyle(.plain)
                    signOutButton
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
        
    }
    
    
    var profileBanner : some View {
        VStack{
            VStack{
                let firstName = homeVM.userProfile.sharedInfo.firstName
                let lastName = homeVM.userProfile.sharedInfo.lastName
                let empty = firstName.isEmpty || lastName.isEmpty
                HStack{
                    Text(empty ? "No Name" : firstName)
                        .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                        .foregroundColor(empty ? AppColor.normal : AppColor.fg )
                        .kerning(AppFonts.titleKerning)
                    Text(empty ? String() : lastName)
                        .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                        .foregroundColor(empty ? AppColor.normal : AppColor.fg )
                        .kerning(AppFonts.titleKerning)
                    Spacer()
                }
            }
        }
        .padding()
    }
    
    var signOutButton : some View {
        StandardButton(label: "SIGN OUT", function: {
            homeVM.purgeData()
            transactionVM.purgeData()
            FirebaseUtils().signOut()
            signInVM.showHome = false
            signUpVM.showHome = false
            
        }).primaryButtonLarge
            .padding()
    }
    
    
}


