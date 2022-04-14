//
//  IncomeItemMiniView.swift
//  Fidget
//
//  Created by Ben Nelson on 4/11/22.
//

import SwiftUI

struct IncomeItemMiniView : View {
    @Binding var incomeItem : Budget.IncomeItem
    //@State var onEdit : () -> Void = {}
    @State var onDelete : () -> Void = {}
    @State private var showDeleteConfirmation = false
    
    var body: some View{
        
        
        
        HStack{
            VStack(alignment: .leading){
                Text(incomeItem.name)
                    .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.inputFieldSize))
                Text("$\(Int(incomeItem.amount))")
                    .font(Font.custom(AppFonts.mainFontRegular, size: AppFonts.inputFieldSize))
            }
            Spacer()
            HStack{
                
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .foregroundColor(AppColor.alert)
                        .frame(width: 25, height: 25)
                        .onTapGesture {
                            UXUtils.hapticButtonPress()
                            showDeleteConfirmation.toggle()
                        }
                    
            
                
            }
            .confirmationDialog("Delete Source of Income", isPresented: $showDeleteConfirmation){
                StandardButton(label: "Yes", function: {
                    self.onDelete()
                })
            } message : {
                Text("Are you sure you want to delete this source of income?")
            }
        }
    }
    
}
