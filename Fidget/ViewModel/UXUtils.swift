//
//  UXUtils.swift
//  Fidget
//
//  Created by Ben Nelson on 3/24/22.
//

import SwiftUI

struct UXUtils {
    
    static func hapticButtonPress(){
        let impactMed = UIImpactFeedbackGenerator(style: .medium)
        impactMed.impactOccurred()
    }
}

