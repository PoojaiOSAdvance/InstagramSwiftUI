//
//  BrowseView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 28/03/23.
//

import SwiftUI

struct BrowseView: View {

    var postArrayObj  : PostArrayObject
    var body: some View {
        ScrollView(.vertical,showsIndicators: false, content: {
            CarousreView(postArrayObj: postArrayObj)
            ImageGridView(postArrayObj: postArrayObj)
        })
        .navigationBarTitle("Browse")
        .navigationBarTitleDisplayMode(.inline)
        Spacer()
        
    }
}

struct BrowseView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            BrowseView(postArrayObj: PostArrayObject(shuffled: true))
        }
    }
}
