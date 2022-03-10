//
//  UserUtils.swift
//  Fidget
//
//  Created by Benjamin Nelson on 3/2/22.
//

import SwiftUI
import Firebase

struct UserUtils {
    static func userSignedIn() -> Bool {
        return Auth.auth().currentUser?.uid != nil
    }
}
