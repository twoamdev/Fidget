//
//  FrequentBucketsView.swift
//  Fidget
//
//  Created by Ben Nelson on 3/22/22.
//

import SwiftUI

struct MiniBudgetView: View {
    @EnvironmentObject var homeViewModel : HomeViewModel
    
    var body: some View{
        VStack(spacing: 0){
            let (balance, capacity , percent) = homeViewModel.budgetBalance()
            HStack{
                Text(FormatUtils.getCurrentMonth())
                    .font(Font.custom(AppFonts.mainFontMedium, size: 40))
                    .kerning(AppFonts.titleKerning)
                    .foregroundColor(AppColor.fg)
                Spacer()
                Text("\(percent)%")
                    .font(Font.custom(AppFonts.mainFontMedium, size: 40))
                    .tracking(-1)
                    .foregroundColor(AppColor.fg)
            }
            .padding(.vertical)
            ProgressView(value: balance , total: capacity)
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8.0, style: .continuous))
        .padding()
    }
}

struct FrequentBucketsView_Previews: PreviewProvider {
    static var previews: some View {
        MiniBudgetView()
    }
}
