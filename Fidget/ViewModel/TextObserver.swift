//
//  SwiftUIView.swift
//  Fidget
//
//  Created by Benjamin Nelson on 3/2/22.
//

import SwiftUI

class TextFieldObserver : ObservableObject {
    @Published var debouncedText = ""
    @Published var searchText = ""
    
    init(delay: DispatchQueue.SchedulerTimeType.Stride) {
        self.$searchText
            .debounce(for: delay, scheduler: DispatchQueue.main)
            .assign(to: &self.$debouncedText)
    }
}
