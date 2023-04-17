//
//  FeedView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 27/03/23.
//

import SwiftUI

struct FeedView: View ,onRefreshPost{
  
    func onDeletePost() {
        guard let _delegate = delegate else{return}
        
        _delegate.onDeletePost()
        
    }
    
    mutating func postDelete() {
        postArrayObj = PostArrayObject(shuffled: false)
    }
    
    @ObservedObject var postArrayObj  :PostArrayObject
    var title :String
    var delegate : onRefreshPost?

    var body: some View {
        ScrollView(.vertical,showsIndicators: false,content: {
            LazyVStack {
                ForEach(postArrayObj.dataArray,id: \.self) { post in
                   
                    PostView(post: post,addHeartAnimationToView: true, showHeaderAndFooter: true,delegate: self)
                }
            }
        })
        .navigationBarTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FeedView(postArrayObj: PostArrayObject(shuffled: false), title: "FEED")
        }
    }
}
