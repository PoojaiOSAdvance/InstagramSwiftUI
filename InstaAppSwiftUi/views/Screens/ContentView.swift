//
//  ContentView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 27/03/23.
//

import SwiftUI

struct ContentView: View {

    var body: some View {
        
        AppTabbedView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
