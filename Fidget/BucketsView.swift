//
//  BucketsView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI
struct Bucket: Hashable{
    var name: String
    var value: Float
    var capacity: Float
    var displayValue : Float
    init(name: String, value: Float, capacity: Float){
        self.name = name
        self.value = value
        self.capacity = capacity
        self.displayValue = capacity * value
        
    }
}


struct BucketsView: View {
    @State private var temp: String = ""
    @State private var progressValue: Float = 0.0
    
    var appRed = ColorPallete().appRed
    var appGreen = ColorPallete().appGreen
    var appYellow = ColorPallete().appYellow
    var buckets: [Bucket] = [Bucket(name:"Fun",value: 0.1, capacity: 100),
                             Bucket(name:"Rent",value: 0.3, capacity: 1200),
                             Bucket(name:"Car",value: 0.4, capacity: 356),
                             Bucket(name:"Insurance",value: 1.1, capacity: 78),
                             Bucket(name:"Groceries",value: 0.4, capacity: 550),
                             Bucket(name:"Cell Phone",value: 0.7, capacity: 80),
                             Bucket(name:"Education",value: 0.85, capacity: 330),
                             Bucket(name:"Gym",value: 0.2, capacity: 65),
                             Bucket(name:"Misc",value: 0.34, capacity: 140)]
    
    
    
    var body: some View {
        VStack(){
            Spacer().frame(height:1)
                
                //Rectangle()
                    //.frame(width: .infinity, height: 130)
                    //.foregroundColor(ColorPallete().tempPrimaryColor)
                    //.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            /*
            Text("Buckets")
                .font(Font.custom(AppFonts().mainFontRegular, size: 25))
                .frame(maxWidth: .infinity)
                .padding()
                .background(ColorPallete().tempFGColor)
                .foregroundColor(ColorPallete().tempTitleColor)*/
            
            ScrollView {
                
                ForEach(buckets, id: \.self) { mybucket in
                    HStack(){
                        ZStack(){
                            GeometryReader{ geometry in
                                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                                    .foregroundColor(ColorPallete().tempNeutralColor)
                                let x = mybucket.value
                                let clr = mybucket.value > 1.0 ? Color.red : ColorPallete().tempPrimaryColor
                                LinearGradient(gradient: Gradient(colors: [ clr ,ColorPallete().tempNeutralColor]),startPoint: .leading, endPoint: .trailing)
                                    .mask(
                                        HStack(){
                                            
                                            Rectangle()
                                                .frame(width: CGFloat(x)*geometry.size.width, height: geometry.size.height)
                                            .cornerRadius(5)
                                        }
                                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                                            
                                    )
                                    
                                
                                
                                
                                
                                
                            }
                            .frame(height: 80)
                            HStack(){
                                ZStack(){
                                    HStack(){
                                        VStack(alignment: .leading){
                                            Text(mybucket.name)
                                                .font(Font.custom(AppFonts().mainFontBold, size: 20))
                                                .foregroundColor(ColorPallete().tempFGColor)
                                            Text("$\(Int(mybucket.displayValue)) / $\(Int(mybucket.capacity)) Spent")
                                                .font(Font.custom(AppFonts().mainFontRegular, size: 12))
                                                .foregroundColor(ColorPallete().tempFGColor)
                                            
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                                        Spacer()
                                        let moneyLeft = Int(mybucket.capacity - mybucket.displayValue)
                                        let displayColor = moneyLeft >= 0 ? ColorPallete().tempFGColor : Color.red
                                        Text(String(moneyLeft)+" ")
                                            .font(Font.custom(AppFonts().mainFontMedium, size: 40))
                                            .tracking(-2)
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                                            .foregroundColor(displayColor)
                                    }
                                }
                            }
                        }
                    }
                    .cornerRadius(5)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: -7.5, trailing: 0))
                    
                    //.padding(EdgeInsets(top: 2, leading: 15, bottom: 2, trailing: 15))
                    
                }
            }
        }
        .background(ColorPallete().tempBGColor)
    }
}

struct BucketsView_Previews: PreviewProvider {
    static var previews: some View {
        BucketsView()
    }
}

