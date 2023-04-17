//
//  SettingRowView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 29/03/23.
//

import SwiftUI

struct SettingRowView: View {
    var leftIcon : String
    var text:String
    var color:Color
    var body: some View {

        HStack{
            ZStack{
                RoundedRectangle(cornerRadius: 8,style: .continuous).fill(color)
                Image(systemName: leftIcon).font(.title3).foregroundColor(.white)
            }
            .frame(width: 36,height: 36,alignment: .center)
            Text(text).foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right").font(.headline).foregroundColor(.primary)
        }
        .padding(.vertical,4)
        
    }
}

struct SettingRowView_Previews: PreviewProvider {
    static var previews: some View {
        SettingRowView(leftIcon: "heart.fill", text: "title", color: .red).previewLayout(.sizeThatFits)
    }
}
