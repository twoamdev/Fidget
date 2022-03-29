//
//  InvitationView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/27/22.
//

import SwiftUI

struct InvitationView: View {
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
                    var count : Int = 5
                    var names = ["Family Budget","Work Budget", "Fun Budget", "Movie Budget", "Random Budget"]
                    var usernames = ["brian","garetnelson", "zoemargot2", "joe_nelson", "mrbennelson"]
                    
                    ForEach(0..<count, id: \.self) { i in
                        BudgetInviteCardView(budgetName: names[i], requestUsername: usernames[i], selected: .constant(false),
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
