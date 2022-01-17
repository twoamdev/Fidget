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
    var r: Double
    var g: Double
    var b: Double
    init(name: String, value: Float, r: Double, g: Double, b: Double){
        self.name = name
        self.value = value
        self.r = r
        self.g = g
        self.b = b
    }
}


struct BucketsView: View {
    @State private var temp: String = ""
    @State private var progressValue: Float = 0.0
    
    var buckets: [Bucket] = [Bucket(name:"Fun",value: 0.1, r:0.0, g:1.0,b:0.5),
                             Bucket(name:"Rent",value: 0.3, r:0.0, g:1.0,b:0.5),
                             Bucket(name:"Car",value: 0.4, r:0.0, g:1.0,b:0.5),
                             Bucket(name:"Insurance",value: 0.9, r:1.0, g:0.0,b:0.2),
                             Bucket(name:"Groceries",value: 0.4, r:0.0, g:1.0,b:0.5),
                             Bucket(name:"Cell Phone",value: 0.7, r:1.0, g:1.0,b:0.2),
                             Bucket(name:"Education",value: 0.85, r:1.0, g:0.0,b:0.2),
                             Bucket(name:"Gym",value: 0.2, r:0.0, g:1.0,b:0.5),
                             Bucket(name:"Misc",value: 0.34, r:0.0, g:1.0,b:0.5),
    ]
    var body: some View {
        VStack(){
            Text("Buckets")
                .font(.title2)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
            
            ScrollView {
                
                ForEach(buckets, id: \.self) { mybucket in
                    // GeometryReader{ metrics in
                    
                    
                    //Text(mybucket.name)
                    //.frame(width: metrics.size.width / 3.0, alignment: .leading)
                    
                    HStack(){
                        ZStack(){
                            GeometryReader{ geometry in
                                
                                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                                    .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                
                                let x = mybucket.value
                                let barColor = Color(red: mybucket.r, green: mybucket.g, blue: mybucket.b)
                                
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
                                                .font(.system(size: 20))
                                            Text("$35/$500 Spent")
                                                .font(.system(size: 10))
                                                
                                        }
                                        .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 0))
                                        Spacer()
                                        Text(String(Int(mybucket.value*100))+"%")
                                            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
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
