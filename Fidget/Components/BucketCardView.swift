//
//  BucketCardView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/20/22.
//

import SwiftUI

struct BucketCardView: View {
    @EnvironmentObject var viewModel : HomeViewModel
    @State private var showBucketDetails = false
    @State private var showEditButtons = false
    var bucket: Bucket
    var body: some View {
        HStack(){
            ZStack(){
                GeometryReader{ geometry in
                    Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                        .foregroundColor(ColorPallete().mediumFGColor)
                    
                    /*
                    let x = bucket.value
                    
                    LinearGradient(gradient: Gradient(colors: [ ColorPallete().mediumBGColor, ColorPallete().mediumFGColor]),startPoint: .leading, endPoint: UnitPoint(x:CGFloat(x),y:0.5))
                    
                        .mask(
                            VStack(){
                                Rectangle()
                                    .frame(width: CGFloat(x)*geometry.size.width, height: geometry.size.height)
                                    .cornerRadius(5)
                                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
                                    .scaleEffect(y:0.07)
                                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 79.5, trailing: 0))
                            }
                            
                        )*/
                }
                .frame(height: 80)
                HStack(){
                    if showEditButtons {
                        Button(action: {
                            viewModel.removeBucketFromBudget(self.bucket)
                        } ){
                        Image(systemName: "multiply")
                            //.resizable()
                            .padding(6)
                            .frame(width: 30, height: 30)
                            .background(Color.red)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .padding()
                        }
                        
                    }
                    VStack(){
                        HStack(){
                            let displayValue = bucket.value
                            let moneyLeft = Int(bucket.capacity - displayValue)
                            let displayColor = moneyLeft >= 0 ? ColorPallete().mediumBGColor : Color.red
                            let textDisplayColor = moneyLeft >= 0 ? ColorPallete().mediumBGColor : Color.red
                            VStack(alignment: .leading, spacing: 0){
                                Text(bucket.name)
                                    .font(Font.custom(AppFonts().mainFontBold, size: 20))
                                    .foregroundColor(textDisplayColor)
                                HStack(){
                                    Text("$\(Int(displayValue)) / $\(Int(bucket.capacity))")
                                        .font(Font.custom(AppFonts().mainFontRegular, size: 15))
                                        .foregroundColor(textDisplayColor)
                                }
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
                .animation(.easeInOut)
            }
        }
        .sheet(isPresented: $showBucketDetails) {
            BucketSheetView(bucket: bucket)
            
        }
        
        .onTapGesture{
            showBucketDetails.toggle()
        }
         
        
        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onEnded({ value in
                if value.translation.width < 0 && showEditButtons {
                    // left
                    showEditButtons.toggle()
                }

                if value.translation.width > 0 && showEditButtons == false {
                    // right
                    showEditButtons.toggle()
                    
                }
                /*
                if value.translation.height < 0 {
                    // up
                }

                if value.translation.height > 0 {
                    // down
                }
                */
            }))
        
    
        //.cornerRadius(5)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: -7.5, trailing: 0))
        
    }
}

struct BucketCardView_Previews: PreviewProvider {
    static var previews: some View {
        BucketCardView(bucket: Bucket(name: "Bucket Name", value: 200, capacity: 340, rollover: true))
    }
}

