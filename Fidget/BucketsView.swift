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
                             Bucket(name:"Insurance",value: 1.0, capacity: 78),
                             Bucket(name:"Groceries",value: 0.4, capacity: 550),
                             Bucket(name:"Cell Phone",value: 0.7, capacity: 80),
                             Bucket(name:"Education",value: 0.85, capacity: 330),
                             Bucket(name:"Gym",value: 0.2, capacity: 65),
                             Bucket(name:"Misc",value: 0.34, capacity: 140)]
    
    
    
    var body: some View {
        VStack(){
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
                                /*let x = mybucket.value
                                LinearGradient(gradient: Gradient(colors: [ ColorPallete().tempNeutralColor,ColorPallete().tempPrimaryColor]),startPoint: .leading, endPoint: .trailing)
                                    .mask(
                                        HStack(){
                                            
                                            Rectangle()
                                                .frame(width: CGFloat(x)*geometry.size.width, height: geometry.size.height)
                                        }.frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                                    )*/
                                
                                
                                //let data = (1...100).map { "Item \($0)" }
                                let radius = 15.0
                                let height = geometry.size.width/radius
                                let remainder = (height - Double(Int(height)))/2.0
                                var scaling = (geometry.size.width-(radius * remainder))
                                //scaling /= geometry.size.width
                                var scale = scaling / geometry.size.width
                                
                                
                                var rows = [GridItem(.flexible())]
                                //Text("\(scale)")
                                
                                LazyHGrid(rows: rows, spacing: 0) {
                                    ForEach((0...(Int(height))), id: \.self) { y in
                                    Circle()
                                        .fill(Color.white)
                                        .frame(width: radius, height: radius)
                                        
                                        
                                        //.frame(width:circleRadius,height:circleRadius)
                                        
                                    }
                                }
                                .scaleEffect(scale, anchor: .leading)
                                
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
                                        Text(String(Int(mybucket.value*100))+"% ")
                                            .font(Font.custom(AppFonts().mainFontMedium, size: 40))
                                            .tracking(-2)
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                                            .foregroundColor(ColorPallete().tempFGColor)
                                    }
                                }
                            }
                        }
                    }
                    //.cornerRadius(5)
                    //.padding(EdgeInsets(top: 0, leading: 0, bottom: -7.5, trailing: 0))
                    
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

