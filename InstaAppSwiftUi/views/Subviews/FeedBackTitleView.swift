//
//  FeedBackTitleView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 10/04/23.
//

import SwiftUI

struct FeedBackTitleView: View {
    @State var isSelected : Int?
    
     var feedbackTitle : [String] = ["Account related","Wrong Infomation","Delete Account","Delete latest uploaded Feed"]
   
    @Binding var selectedTitle : String // Image show in this screen

    @Environment(\.presentationMode) var presentationMode

    let positions = ["First", "Second", "Third"]
    
    var body: some View {
        
        
        List {
            ForEach(0..<feedbackTitle.count) { index in
                Button(action: {
                    selectFeed(index: index)
                    selectedTitle = feedbackTitle[index]
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        presentationMode.wrappedValue.dismiss()

                    }
                    
                }, label: {
                    
                    HStack{
                        Text(feedbackTitle[index]).font(.subheadline)
                        Image(systemName: "checkmark.circle.fill").foregroundColor(self.isSelected == index ?.red : .clear).tag(index)
                    }

                }).accentColor(.primary)
            }
        }
        .navigationTitle("Menu")
    }

    //MARK: FUCTION
    
    func selectFeed(index:Int){
        
        isSelected = index
    }
}

struct FeedBackTitleView_Previews: PreviewProvider {
    @State static var selectedTitle : String = ""
    static var previews: some View {
        FeedBackTitleView(selectedTitle: $selectedTitle).previewLayout(.sizeThatFits)
    }
}
