//
//  LazzyView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 06/04/23.
//

import Foundation
import SwiftUI

struct LazzyView<Content:View> : View {
    
    var content :()->Content
    
    var body: some View {
        
        self.content()
    }
    
}
