//
//  ChangeNameView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/20/22.
//

import SwiftUI

struct ChangeNameView: View {
    @Binding var show : Bool
    @EnvironmentObject var infoVM : PersonalInfoViewModel
    @EnvironmentObject var homeVM : HomeViewModel
    @State var infoTextColor = AppColor.normalMoreContrast
    let infoTextSpacing = 1.0
    
    var body: some View{
        
        ZStack{
            AppColor.bg
                .transition(.moveInTrailingMoveOutTrailing)
                .onTapGesture {
                    self.dismissFocusOnAll()
                }
            
            VStack{
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
                        Text("Set your name.")
                            .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.titleFieldSize))
                            .kerning(AppFonts.titleKerning)
                            .foregroundColor(AppColor.fg)
                        Spacer()
                    }
                    .padding()
                    
                    
                    VStack(alignment: .leading, spacing: infoTextSpacing){
                        Text("Current Name")
                            .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.userFieldInfoSize))
                            .foregroundColor(infoTextColor)
                        StandardTextField(locked: true, label: String(), text: $infoVM.currentFullName)
                        
                        ScrollView{
                            VStack{
                                VStack(){
                                    StandardTextField(label : "First Name",text: $infoVM.inputFirstName, verifier: $infoVM.inputFirstNameIsValid, infoMessage: .constant("First Name")).normalWithVerify
                                        .disableAutocorrection(true)
                                        .onChange(of: infoVM.inputFirstName, perform: { change in
                                            infoVM.validateFirstName(change)
                                        })
                                    StandardTextField(label : "Last Name",text: $infoVM.inputLastName, verifier: $infoVM.inputLastNameIsValid, infoMessage: .constant("Last Name")).normalWithVerify
                                        .disableAutocorrection(true)
                                        .onChange(of: infoVM.inputLastName, perform: { change in
                                            infoVM.validateLastName(change)
                                        })
                                }
                                .padding(.vertical)
                                
                                StandardButton(label: "CHANGE NAME") {
                                    homeVM.changeFirstAndLastName(infoVM.inputFirstName, infoVM.inputLastName)
                                    show.toggle()
                                }
                                .disabled(!infoVM.inputFirstNameIsValid || !infoVM.inputLastNameIsValid)
                            }
                        }
                        
                        
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                }
                
            }
        }
        .transition(.moveInTrailingMoveOutTrailing)
    }
}
