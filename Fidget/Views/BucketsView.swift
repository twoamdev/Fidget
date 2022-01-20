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
            //Rectangle()
               // .foregroundColor(ColorPallete().tempNeutralColor)
            HStack(){
                VStack(){
                    Text("Feb")
                        .font(Font.custom(AppFonts().mainFontMedium, size: 60))
                        .foregroundColor(ColorPallete().accentColor)
                        //.padding(EdgeInsets(top: 0, leading: 0, bottom: 0,ectrailing: 0))
                    
                }
                //.padding(EdgeInsets(top: 15, leading: 15, bottom: 5, trailing: 0))
                Spacer()
                Button(action: {
                    showingAlert = true
                }, label: {
                    //Image(systemName:"chevron.right")
                    Image(systemName:"plus")
                        .resizable().frame(width: 50, height: 50)
                        .frame(width: 60, height: 60)
                        .foregroundColor(ColorPallete().accentColor)
                        //.background(ColorPallete().tempNeutralColor)
                        .clipShape(Circle())
                })
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text("Create New Bucket"),
                            message: Text("Will work one day..."),
                            dismissButton: .default(Text("Ok"))
                        )
                    }
            }.padding(EdgeInsets(top: 40, leading: 10, bottom: 0, trailing: 5))

            
            ScrollView {
                ForEach(buckets, id: \.self) { mybucket in
                    BucketCardView(bucket: mybucket)
                }
            }
            .padding(EdgeInsets(top: -4, leading: 0, bottom: 0, trailing: 0))
            
            
            
            
            
        }
        .background(ColorPallete().bgColor)
        
    }
}

struct BucketsView_Previews: PreviewProvider {
    static var previews: some View {
        BucketsView()
    }
}

