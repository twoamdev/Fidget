//
//  ProfileView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var profileViewModel : ProfileViewModel
    @EnvironmentObject var transactionViewModel : TransactionViewModel
    @EnvironmentObject var signInVM : SignInViewModel
    @EnvironmentObject var signUpVM : SignUpViewModel
    
    var body: some View {
        VStack{
            StandardButton(label: "SIGN OUT", function: {
                profileViewModel.signOut()
                signInVM.showHome = false
                signUpVM.showHome = false
                
            }).normalButtonLarge
                .padding(.horizontal)
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
