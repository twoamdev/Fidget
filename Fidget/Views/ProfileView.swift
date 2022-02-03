//
//  ProfileView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var signInViewModel : SignInViewModel
    @ObservedObject var profileViewModel : ProfileViewModel = ProfileViewModel()
    @State var isButtonHidden : Bool = true
    var body: some View {
        
        VStack(){
            Text("PROFILE")
            Spacer()
            if profileViewModel.loading || self.isButtonHidden {
                
                Text("LOADING")
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        self.isButtonHidden = false
                    }
                }
            }
            else{
                profile
            }
            Spacer()

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
    
    var profile : some View{
        VStack(){
            HStack(){
                Text("First Name")
                Spacer()
                Text(profileViewModel.firstName)
            }
            .padding(.horizontal)
            HStack(){
                Text("Last Name")
                Spacer()
                Text(profileViewModel.lastName)
            }
            .padding(.horizontal)
            HStack(){
                Text("username")
                Spacer()
                Text(profileViewModel.userName)
            }
            .padding(.horizontal)
            HStack(){
                Text("email")
                Spacer()
                Text(profileViewModel.emailAddress)
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
