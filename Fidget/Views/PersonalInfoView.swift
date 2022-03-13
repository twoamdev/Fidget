//
//  PersonalInfoView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/12/22.
//

import SwiftUI

struct PersonalInfoView: View {
    var body: some View {
        VStack{
            Text("Profile Icon")
            Text("Name")
            Text("Username")
            Text("Email")
            Text("ChangePassword")
        }
        
    }
}

struct PersonalInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalInfoView()
    }
}
