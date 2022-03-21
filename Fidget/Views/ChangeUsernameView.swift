//
//  ChangeUsernameView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/16/22.
//

import SwiftUI

struct ChangeUsernameView: View {
    @Binding var show : Bool
    @EnvironmentObject var infoVM : PersonalInfoViewModel
    @EnvironmentObject var homeVM : HomeViewModel
    @StateObject var usernameObserver = TextFieldObserver(delay: 0.5)
    @State var infoTextColor = AppColor.normalMoreContrast
    let infoTextSpacing = 1.0
    
    var body: some View{
        Color.white
            .transition(.moveInTrailingMoveOutTrailing)
            
            
        
         VStack{
             VStack{
                 HStack{
                     Spacer()
                     Button(action:{
                         show.toggle()
                     }, label: {
                         Image(systemName: "xmark.circle.fill")
                             .resizable()
                             .frame(width: 25, height: 25)
                             .foregroundColor(AppColor.primary)
                     })
                     
                 }
             }.padding()
             HStack{
                 Text("Set your username.")
                     .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                     .kerning(AppFonts.titleKerning)
                     .foregroundColor(AppColor.fg)
                 Spacer()
             }
             .padding()
                 
             
             VStack(alignment: .leading, spacing: infoTextSpacing){
                 Text("Current Username")
                     .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                     .foregroundColor(infoTextColor)
                // StandardTextField(label: String(), text: $infoVM.currentUsername)
                 //    .disabled(true)
                 StandardTextField(locked: true, label: String(), text: $infoVM.currentUsername)
                 
                 
                 StandardTextField(label: "New Username", text: $usernameObserver.searchText, verifier: $infoVM.usernameIsValid, loading: $infoVM.isUsernameLoading).normalWithVerify
                     .disableAutocorrection(true)
                     .autocapitalization(.none)
                     .submitLabel(.done)
                     .onReceive(usernameObserver.$debouncedText, perform:{ value in
                         infoVM.validateUsername(value)
                     })
                 
                     .onChange(of: usernameObserver.searchText, perform:{ _ in
                         infoVM.usernameIsLoading()
                     })
                  
                 VStack(alignment: .leading){
                     StandardUserTextHelper(message: "Requires at least 3 characters.", indicator: $infoVM.usernameLengthIsValid)
                     StandardUserTextHelper(message: "Only letters, numbers and underscores.", indicator: $infoVM.usernameCharsAreValid)
                     StandardUserTextHelper(message: "Can't already be in use.", indicator: $infoVM.usernameIsValid)
                 }
                 .padding(.vertical)
                 
                 StandardButton(label: "CHANGE USERNAME") {
                     homeVM.changeUsername(infoVM.inputUsername)
                     show.toggle()
                 }
                 .disabled(!infoVM.usernameIsValid || infoVM.isUsernameLoading)
                 
             }
             .padding(.horizontal)
             
             Spacer()
             
         }
         .transition(.moveInTrailingMoveOutTrailing)
    }
}

/*
struct ChangeUsernameView_Previews: PreviewProvider {
    static var previews: some View {
        ChangeUsernameView()
    }
}
*/
