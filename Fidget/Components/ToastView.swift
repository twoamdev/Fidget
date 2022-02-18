//
//  ToastView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 1/27/22.
//

import SwiftUI

struct ToastView: View {
    @State var message : String
    @Binding var show : Bool
    var body: some View {
        withAnimation{
            VStack(){
                
                HStack {
                    Image(systemName: "checkmark.seal")
                    Text(message)
                }.font(.headline)
                    .foregroundColor(.primary)
                    .padding([.top,.bottom],20)
                    .padding([.leading,.trailing],40)
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(Capsule())
            }
            .transition(AnyTransition.move(edge: .top).combined(with: .opacity))
            
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        show.toggle()
                    }
                    
                }
            })
            
            .padding(.vertical)
        }
    }
}

struct ToastView_Previews: PreviewProvider {
    static var previews: some View {
        ToastView(message: "all done", show: .constant(true))
    }
}
