//
//  CircularProgressView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/20/22.
//

import SwiftUI

struct CircularProgressView: View {
    var percentage: Float
    var bgcolor: Color
    var body: some View {
        ZStack(){
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(1.0)
                .foregroundColor(bgcolor)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(percentage))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.red)
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(percentage: 0.5, bgcolor: ColorPallete().mediumBGColor)
    }
}
