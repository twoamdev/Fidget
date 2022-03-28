//
//  BudgetCardView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/27/22.
//

import SwiftUI

struct BudgetCardView: View {
    @State var budgetName : String
    @State var bucketCount : Int
    @State var sharedUserCount : Int
    @State var incomeAmount : String
    @Binding var selected : Bool
    
    var body: some View {
        VStack{
            HStack{
                VStack(alignment: .leading){
                    Text(budgetName)
                        .font(Font.custom(AppFonts.mainFontBold, size: AppFonts.inputFieldSize * 1.23))
                        .foregroundColor(selected ? AppColor.bg : AppColor.fg)
                    if sharedUserCount < 2 {
                        HStack(spacing: 3){
                            Image(systemName: "person.crop.circle.fill")
                                .font(Font.custom(AppFonts.mainFontMedium, size: AppFonts.inputFieldSize))
                                .foregroundColor(selected ? AppColor.bg : AppColor.normalMoreContrast)
                        Text("Private")
                            .font(Font.custom(AppFonts.mainFontMedium, size: AppFonts.inputFieldSize))
                            .foregroundColor(selected ? AppColor.bg : AppColor.normalMoreContrast)
                        }
                    }
                    else{
                        HStack(spacing: 3){
                            Image(systemName: "person.2.circle.fill")
                                .font(Font.custom(AppFonts.mainFontMedium, size: AppFonts.inputFieldSize))
                                .foregroundColor(selected ? AppColor.bg : AppColor.normalMoreContrast)
                        Text("\(sharedUserCount) Shared Users")
                            .font(Font.custom(AppFonts.mainFontMedium, size: AppFonts.inputFieldSize))
                            .foregroundColor(selected ? AppColor.bg : AppColor.normalMoreContrast)
                        }
                    }
                    
                    
                }
                Spacer()
                VStack(alignment: .trailing){
                    Text("\(bucketCount) Buckets")
                        .font(Font.custom(AppFonts.mainFontMedium, size: AppFonts.inputFieldSize))
                        .foregroundColor(selected ? AppColor.bg : AppColor.fg)
                    Text("\(incomeAmount) / Month")
                        .font(Font.custom(AppFonts.mainFontMedium, size: AppFonts.inputFieldSize))
                        .foregroundColor(selected ? AppColor.bg : AppColor.fg)
                }
            }
            .padding()
            .background(selected ? AppColor.primary : AppColor.normal)
            .cornerRadius(AppStyle.cornerRadius)
            
        }
    }
}

/*
struct BudgetCardView_Previews: PreviewProvider {
    static var previews: some View {
        BudgetCardView(budgetName: "Nelson Family Budget", bucketCount: 200, sharedUserCount: 5, incomeAmount: "$5,204", selected: true)
            //.padding()
    }
}
*/
