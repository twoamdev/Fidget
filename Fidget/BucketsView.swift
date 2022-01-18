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
    var fillColor : Color
    init(name: String, value: Float){
        self.name = name
        self.value = value
        self.fillColor = ColorPallete().appGreen
        if self.value > 0.6{
            self.fillColor = ColorPallete().appYellow
        }
        if self.value > 0.8{
            self.fillColor = ColorPallete().appRed
        }
    }
}


struct BucketsView: View {
    @State private var temp: String = ""
    @State private var progressValue: Float = 0.0
    
    var appRed = ColorPallete().appRed
    var appGreen = ColorPallete().appGreen
    var appYellow = ColorPallete().appYellow
    var buckets: [Bucket] = [Bucket(name:"Fun",value: 0.1),
                             Bucket(name:"Rent",value: 0.3),
                             Bucket(name:"Car",value: 0.4),
                             Bucket(name:"Insurance",value: 0.9),
                             Bucket(name:"Groceries",value: 0.4),
                             Bucket(name:"Cell Phone",value: 0.7),
                             Bucket(name:"Education",value: 0.85),
                             Bucket(name:"Gym",value: 0.2),
                             Bucket(name:"Misc",value: 0.34)]
    
    
    
    var body: some View {
        VStack(){
            Text("Buckets")
                .font(Font.custom(AppFonts().mainFontRegular, size: 25))
                .frame(maxWidth: .infinity)
                .padding()
                .background(ColorPallete().tempFGColor)
                .foregroundColor(ColorPallete().tempTitleColor)
            
            ScrollView {
                
                ForEach(buckets, id: \.self) { mybucket in
                    HStack(){
                        ZStack(){
                            GeometryReader{ geometry in
                                
                                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                                    .foregroundColor(ColorPallete().tempNeutralColor)
                                
                                let x = mybucket.value
                                let barColor = mybucket.fillColor
                                
                                Rectangle()
                                    .frame(width: CGFloat(x)*geometry.size.width, height: geometry.size.height)
                                    .foregroundColor(barColor)
                            }
                            .frame(height: 50)
                            
                            
                            HStack(){
                                ZStack(){
                                    HStack(){
                                        VStack(alignment: .leading){
                                            Text(mybucket.name)
                                                .font(Font.custom(AppFonts().mainFontRegular, size: 20))
                                                .foregroundColor(ColorPallete().tempPrimaryColor)
                                            Text("$35/$500 Spent")
                                                .font(Font.custom(AppFonts().mainFontRegular, size: 10))
                                                .foregroundColor(ColorPallete().tempPrimaryColor)
                                            
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                                        Spacer()
                                        Text(String(Int(mybucket.value*100))+"%")
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                                            .foregroundColor(ColorPallete().tempPrimaryColor)
                                    }
                                }
                            }
                        }
                    }
                    .cornerRadius(15)
                    
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15))
                    Divider()
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


/*
 
 
 HStack(){
 Text(name)
 .padding()
 Spacer()
 
 
 GeometryReader{ geometry in
 
 
 Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
 
 .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
 
 Rectangle()
 .frame(width: 0.2*geometry.size.width, height: geometry.size.height)
 .foregroundColor(Color(red: 0, green: 1, blue: 0.6))
 
 }
 .frame(height: 20)
 .cornerRadius(30)
 .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
 
 } //End of HStack
 */
