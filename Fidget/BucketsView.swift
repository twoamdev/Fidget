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
    @State private var showingAlert = false
    
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
            Spacer().frame(height:4)
            ZStack(){
                Rectangle()
                    .frame(width: .infinity, height: 110)
                    .foregroundColor(ColorPallete().tempNeutralColor)
                    //.padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .cornerRadius(5)
                HStack(){
                    Spacer()
                    Button(action: {
                        showingAlert = true
                    }, label: {
                        //Image(systemName:"chevron.right")
                        Image(systemName:"plus")
                            .resizable().frame(width: 50, height: 50)
                            .frame(width: 60, height: 60)
                            .foregroundColor(ColorPallete().tempFGColor)
                            .background(ColorPallete().tempNeutralColor)
                            .clipShape(Circle())
                    }).padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
                        .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Create New Bucket"),
                            message: Text("Will work one day..."),
                            dismissButton: .default(Text("Ok"))
                        )
                        }
                }
            }
            
            
            
            ScrollView {
                
                ForEach(buckets, id: \.self) { mybucket in
                    HStack(){
                        ZStack(){
                            GeometryReader{ geometry in
                                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                                    .foregroundColor(ColorPallete().tempNeutralColor)
                                let x = mybucket.value
                                
                                LinearGradient(gradient: Gradient(colors: [ ColorPallete().tempNeutralColor]),startPoint: .leading, endPoint: .trailing)
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
                                        let moneyLeft = Int(mybucket.capacity - mybucket.displayValue)
                                        let displayColor = moneyLeft >= 0 ? ColorPallete().tempFGColor : Color.red
                                        VStack(alignment: .leading){
                                            Text(mybucket.name)
                                                .font(Font.custom(AppFonts().mainFontBold, size: 20))
                                                .foregroundColor(displayColor)
                                            Text("$\(Int(mybucket.displayValue)) / $\(Int(mybucket.capacity)) Spent")
                                                .font(Font.custom(AppFonts().mainFontRegular, size: 12))
                                                .foregroundColor(displayColor)
                                            
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                                        Spacer()
                                        
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
            }.padding(EdgeInsets(top: -4, leading: 0, bottom: 0, trailing: 0))
        }
        .background(ColorPallete().tempBGColor)
    }
}

struct BucketsView_Previews: PreviewProvider {
    static var previews: some View {
        BucketsView()
    }
}

