//
//  ProfileView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var homeVM : HomeViewModel
    @EnvironmentObject var profileViewModel : ProfileViewModel
    @EnvironmentObject var signInVM : SignInViewModel
    @EnvironmentObject var signUpVM : SignUpViewModel
    @State var showDeleteView : Bool = false
    
    var body: some View {
        VStack{
            profileBanner
            List{
                
                NavigationLink(destination: PersonalInfoView()) {
                    StandardLabel(labelText: "Personal Info", labelIconName: "person.circle")
                        .padding(.vertical)
                }
                .navigationBarTitle("", displayMode: .inline)
                StandardLabel(labelText: "Settings", labelIconName: "gear")
                    .padding(.vertical)
                
                NavigationLink(destination:
                                DeleteAccountView(showDeleteView: $showDeleteView)
                                .environmentObject(homeVM)
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
    
    var profileBanner : some View {
        VStack{
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: AppFonts.titleFieldSize, height: AppFonts.titleFieldSize)
                .foregroundColor(AppColor.normal)
            }
        .padding()
    }
    
    var signOutButton : some View {
        StandardButton(label: "SIGN OUT", function: {
            FirebaseUtils().signOut()
            signInVM.showHome = false
            signUpVM.showHome = false
            
        }).normalButtonLarge
            .padding(.horizontal)
            .padding()
    }
    
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}


