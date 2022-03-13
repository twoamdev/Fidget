//
//  StyleUtils.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/17/22.
//

import Foundation
import SwiftUI

struct AppColor{

    static let primary : Color = Color(.systemPink)
    static let normal : Color = Color(.systemGray6)
    static let normalFocused : Color = Color(.systemGray)
    static let bg : Color = Color(.white)
    static let fg : Color = Color(.black)
    static let alert : Color = Color(.systemRed)
    static let green : Color = Color(.systemGreen)
    
}

struct AppFonts{
    static let mainFontRegular = "DMSans-Regular"
    static let mainFontMedium = "DMSans-Medium"
    static let mainFontBold = "DMSans-Bold"
    
    static let userFieldInfoSize : Double = 13.5
    static let inputFieldSize : Double = 15.0
    static let navTitleFieldSize : Double = 20.0
    static let buttonLabelSize : Double = 15.0
    static let titleFieldSize : Double = 40.0
    
    static let titleKerning : CGFloat = -2.0
}

struct AppStyle{
    static let cornerRadius : Double = 15.0
}
