//
//  ProfileView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profileViewModel : ProfileViewModel
    @EnvironmentObject var signInViewModel : SignInViewModel
    @EnvironmentObject var homeViewModel : HomeViewModel
    @EnvironmentObject var transactionViewModel : TransactionViewModel
    @State var show : Bool = false
    
    
    var body: some View {
       
            
        NavigationView{
            VStack(){
                Text("PROFILE")
                Spacer()
                if profileViewModel.loadingProfile{
                    ProgressView()
                }
                else{
                    profile
                }
                Spacer()
                
                if homeViewModel.userHasBudget{
                    NavigationLink(destination: StartBudgetView(showBudgetNavigationViews: $show)
                                    .environmentObject(homeViewModel), isActive: $show)
                    {
                        Text("Add Another Budget")
                    }
                }
                
                 Button("Sign Out"){
                     homeViewModel.removeBudgetListener()
                     transactionViewModel.removeSharedDataListeners()
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
                Text(profileViewModel.profile.sharedInfo.firstName)
            }
            .padding(.horizontal)
            HStack(){
                Text("Last Name")
                Spacer()
                Text(profileViewModel.profile.sharedInfo.lastName)
            }
            .padding(.horizontal)
            HStack(){
                Text("username")
                Spacer()
                Text(profileViewModel.profile.sharedInfo.username)
            }
            .padding(.horizontal)
            HStack(){
                Text("email")
                Spacer()
                Text(profileViewModel.profile.privateInfo.emailAddress)
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
