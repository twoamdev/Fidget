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
    @ObservedObject var bucketsViewModel = BucketsViewModel()
    var body: some View {
        NavigationView {
            VStack(){
                //ColorPallete().mediumFGColor.edgesIgnoringSafeArea(.all)
                if bucketsViewModel.userHasBudget {
                    
                    Text("HERE'S THE LIST OF BUCKETS")
                    
                }
                else{
                    
                    NavigationLink(destination: CreateBudgetView()
                                    .environmentObject(bucketsViewModel))
                    {
                        Image(systemName: "plus")
                            .resizable()
                            .padding(6)
                            .frame(width: 60, height: 60)
                            .background(Color.blue)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                    }
                    
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


