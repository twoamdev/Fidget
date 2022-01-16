//
//  AllocateView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/14/22.
//

import SwiftUI

struct AllocateView: View {
    @State private var userMessage: String = ""
    @State private var moneyAmount: String = ""
    var body: some View {
        
        VStack{
            
            Text("Allocate")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(Color.white)
                
           
            Spacer()
            HStack{
                TextField("/ :", text: $userMessage)
                
                    .padding(EdgeInsets(top: 15, leading: 10, bottom: 15, trailing: 0))
                    .textFieldStyle(.roundedBorder)
                    
                
                TextField("$", text: $moneyAmount)
                
                    .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.decimalPad)
                
                
                Button("Send"){
                    
                }
                .foregroundColor(Color.white)
                    
                        
                Spacer()
            }
            .background(Color.blue)
            
            
        }
        
        
    }
    
    
}

struct AllocateView_Previews: PreviewProvider {
    static var previews: some View {
        AllocateView()
    }
}
