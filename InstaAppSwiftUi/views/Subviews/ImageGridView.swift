//
//  ImageView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 28/03/23.
//

import SwiftUI

struct ImageGridView: View {
    @ObservedObject var postArrayObj  :PostArrayObject

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                           ],
                  alignment: .center,
                  spacing: nil,
                  pinnedViews: [],
                  content:{
            ForEach(postArrayObj.dataArray,id: \.self) { post in
                NavigationLink(destination:
                                FeedView(postArrayObj: PostArrayObject(post: post), title: "Post")
                , label: {
                    PostView(post: post, addHeartAnimationToView: false, showHeaderAndFooter: false)
                })

            }
        })
    }
}

struct ImageGridView_Previews: PreviewProvider {
    static var previews: some View {
        ImageGridView(postArrayObj: PostArrayObject(shuffled: true)).previewLayout(.sizeThatFits)
    }
}
