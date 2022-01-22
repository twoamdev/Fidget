//
//  LineComponent.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/21/22.
//

import SwiftUI

struct LineComponent: View {
    var lineLength : Double
    var strokeWidth : Double
    var body: some View {
        VStack(){
            GeometryReader(){ geo in
                ZStack(){
                    
                    
                    Path() { path in
                        path.move(to: CGPoint(x: (geo.size.width/2.0)-(lineLength/2.0), y: geo.size.height/2.0))
                        path.addLine(to: CGPoint(x: ((geo.size.width/2.0)+lineLength)-(lineLength/2.0), y: geo.size.height/2.0))
                        //path.addLine(to: CGPoint(x: geo.size.width, y: lineWidth))
                        //path.addLine(to: CGPoint(x: 0, y: lineWidth))
                    }
                    .stroke(lineWidth: strokeWidth)
                    
                }
            }
        }
    }
}

struct LineComponent_Previews: PreviewProvider {
    static var previews: some View {
        LineComponent(lineLength: Double(100.0), strokeWidth: Double(5.0))
    }
}
