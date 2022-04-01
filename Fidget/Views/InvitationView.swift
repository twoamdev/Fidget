//
//  InvitationView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/27/22.
//

import SwiftUI

struct InvitationView: View {
    @EnvironmentObject var homeVM : HomeViewModel
    @Binding var show : Bool
    
    
    var body: some View {
        VStack{
            HStack{
                Text("Budget invites")
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                    .kerning(AppFonts.titleKerning)
                Spacer()
            }
            .padding()
            
            VStack(alignment: .leading, spacing: 1.0){
                Text("Invitations for budget sharing")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                    .foregroundColor(AppColor.normalMoreContrast)
                    .padding(.horizontal)
                
                
                List{
                    let count : Int = homeVM.invitations.count
                    let invites : [Invitation] = homeVM.invitations

                    ForEach(0..<count, id: \.self) { i in
                        let invite : Invitation = invites[i]
                        BudgetInviteCardView(budgetName: invite.getBudgetName(), requestUsername: invite.getSenderUsername(), selected: .constant(false),
                        onAccept: {
                            UXUtils.hapticButtonPress()
                            print("accept")
                            //names.remove(at: i)
                            //usernames.remove(at: i)
                            //count -= 1
                        }, onDecline: {
                            print("decline")
                        })
                        .listRowSeparator(.hidden)
                    }
                }.listStyle(.plain)
            }
            
            Spacer()
            
            HStack{
                StandardButton(label: "DONE", function: {
                    show.toggle()
                }).normalButtonLarge
            }
            .padding()
        }
    }
}

/*
struct InvitationView_Previews: PreviewProvider {
    static var previews: some View {
        InvitationView()
    }
}
*/
