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
    init(name: String, value: Float){
        self.name = name
        self.value = value
    }
}


struct BucketsView: View {
    @State private var temp: String = ""
    @State private var progressValue: Float = 0.0
    
    let buckets: [Bucket] = [Bucket(name:"Fun",value: 0.1),
                             Bucket(name:"Rent",value: 0.3),
                             Bucket(name:"Car",value: 0.4),
                             Bucket(name:"Insurance",value: 0.9),
                             Bucket(name:"Groceries",value: 0.4),
                             Bucket(name:"Cell Phone",value: 0.65),
                             Bucket(name:"Education",value: 0.8),
                             Bucket(name:"Gym",value: 0.2),
                             Bucket(name:"Misc",value: 0.34),
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
                    GeometryReader{ metrics in
                        HStack(){
                            
                            Text(mybucket.name)
                                .frame(width: metrics.size.width / 3.0, alignment: .leading)
                            
                            HStack(){
                                GeometryReader{ geometry in
                                    Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                                        .foregroundColor(Color(red: 0.8, green: 0.8, blue: 0.8))
                                    
                                    let x = mybucket.value
                                    Rectangle()
                                        .frame(width: CGFloat(x)*geometry.size.width, height: geometry.size.height)
                                        .foregroundColor(Color(red: 0, green: 1, blue: 0.6))
                                    
                                }
                                
                                .cornerRadius(30)
                                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 15))
                            }
                        }
                        
                    }
                    .padding(EdgeInsets(top: 5, leading: 15, bottom: 15, trailing: 15))
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
