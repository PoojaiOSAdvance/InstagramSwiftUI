//
//  SettingsLableVie.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 29/03/23.
//

import SwiftUI

struct SettingsLableView: View {
    var lableText :String
    var lableImage : String
    var body: some View {
        VStack {
            HStack{
                Text(lableText).fontWeight(.bold)
                Spacer()
                Image(systemName: lableImage)
                
            }
            Divider()
                .padding(.vertical,4)
        }
    }
}

struct SettingsLableView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsLableView(lableText: "Test Lable", lableImage: "heart").previewLayout(.sizeThatFits)
    }
}
