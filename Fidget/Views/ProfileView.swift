//
//  ProfileView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var signInViewModel : SignInViewModel
    @EnvironmentObject var homeViewModel : HomeViewModel
    @State var show : Bool = false
    @ObservedObject var profileViewModel = ProfileViewModel()
    
    var body: some View {
       
            
        NavigationView{
            VStack(){
                Text("PROFILE")
                Spacer()
                profile
                Spacer()
                
                if homeViewModel.userHasBudget{
                    NavigationLink(destination: StartBudgetView(showBudgetNavigationViews: $show)
                                    .environmentObject(homeViewModel), isActive: $show)
                    {
                        Text("Add Another Budget")
                    }
                }
                
                 Button("Sign Out"){
                     signInViewModel.signOutUser()
                 }
                 .foregroundColor(.white)
                 .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                 .background(Color.blue)
                 .cornerRadius(25)
                 .padding()
                Spacer()
            }
        
        }
    }
    
    var profile : some View{
        VStack(){
            HStack(){
                Text("First Name")
                Spacer()
                Text(profileViewModel.profile.firstName)
            }
            .padding(.horizontal)
            HStack(){
                Text("Last Name")
                Spacer()
                Text(profileViewModel.profile.lastName)
            }
            .padding(.horizontal)
            HStack(){
                Text("username")
                Spacer()
                Text(profileViewModel.profile.username)
            }
            .padding(.horizontal)
            HStack(){
                Text("email")
                Spacer()
                Text(profileViewModel.profile.emailAddress)
            }
            .padding(.horizontal)
        }
    }
    
}


/*
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
*/
