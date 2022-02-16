//
//  AddBucketView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 2/6/22.
//

import SwiftUI

struct AddBucketView: View {
    @Binding var showAddBucketView : Bool
    @Binding var buckets : [Bucket]
    @State var name : String = ""
    @State var spendValue : Double = 0.0
    @State var spendCapacity : Double = 0.0
    @State var rolloverEnabled : Bool = false
    
    var body: some View {
        VStack(){
            Text("Add Bucket")
            
            bucketField
                .padding()
            
            
            HStack(){
            Button(action: {
                showAddBucketView.toggle()
            } ){
            Image(systemName: "multiply")
                //.resizable()
                .padding(6)
                .frame(width: 40, height: 40)
                .background(Color.red)
                .clipShape(Circle())
                .foregroundColor(.white)
                .padding()
            }
            Button(action: {
                buckets.append(Bucket(name: name, value: spendValue, capacity: spendCapacity, rollover: rolloverEnabled))
                showAddBucketView.toggle()
            } ){
            Image(systemName: "checkmark")
                //.resizable()
                .padding(6)
                .frame(width: 40, height: 40)
                .background(Color.green)
                .clipShape(Circle())
                .foregroundColor(.white)
                .padding()
            }
            }
        }
    }
    
    var bucketField : some View{
        VStack(){
            TextFieldView(label: "Name", userInput: $name, errorMessage: "").standardTextField
            HStack(){
                NumberFieldComponent(label: "Already Spent", bindValue: $spendValue)
                    .keyboardType(.decimalPad)
                NumberFieldComponent(label: "Max Spend Amt", bindValue: $spendCapacity)
                    .keyboardType(.decimalPad)
                
            }
            Toggle("Enable Rollover", isOn: $rolloverEnabled)
                .padding(.horizontal)
        }
    }
}


/*
struct AddBucketView_Previews: PreviewProvider {
    static var previews: some View {
        AddBucketView(showAddBucketView: .constant(false),buckets: .constant([Bucket()]))
    }
}

*/
