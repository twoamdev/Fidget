//
//  CircularProgressView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/20/22.
//

import SwiftUI

struct CircularProgressView: View {
    var percentage: Double
    var bgcolor: Color
    var fillColor: Color
    var strokeWidth: Float
    var body: some View {
        ZStack(){
            Circle()
                .stroke(lineWidth: CGFloat(strokeWidth))
                .opacity(1.0)
                .foregroundColor(bgcolor)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(percentage))
                .stroke(style: StrokeStyle(lineWidth: CGFloat(strokeWidth), lineCap: .round ,lineJoin: .round))
                .foregroundColor(fillColor)
                
                //.scaleEffect(x: -1.0)
                //.rotationEffect(.degrees(180.0))
        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(percentage: 0.6, bgcolor: AppColor.normal, fillColor: AppColor.primary, strokeWidth: 20)
    }
}
