//
//  CommentsView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 27/03/23.
//

import SwiftUI

struct CommentsView: View, OnActionRefresh {
  
    
    @Environment(\.colorScheme) var colorScheme
    @State var submissionText :String = ""
    @State var commentArray = [CommentModel]()
    @State var profileImage : UIImage = UIImage(named: .logoLoading)!
    @State var post : PostModel
    @AppStorage(CurrentUserDefaults.userId) var currentUserId : String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName : String?
    @State var selectedCommentId : String = ""
    @State var likedAnimation : Bool = false
    @State var isMoreShowReq : Bool = false


    var body: some View {
        VStack{
            
            // messages scrollview
            
            ScrollView(.vertical,showsIndicators: false,content: {
                LazyVStack{
                    
                    ForEach(commentArray,id : \.self) { comment in
                        Button(action: {
                          
                            if selectedCommentId == "\(comment.id)" {
                                
                                isMoreShowReq  = !isMoreShowReq

                            }
                            else{
                                isMoreShowReq = true
                            }
                            
                            selectedCommentId = "\(comment.id)"
                            
                      
                        }, label: {
                           
                            MessageView(comment: comment,isMoreShow: $isMoreShowReq, islike: comment.liked, isDelete:$isMoreShowReq, islikeReq: $isMoreShowReq, likeAnimation: $likedAnimation, row: $selectedCommentId, post: post,delegate: self)
                            
                        })
                    }
                }
            })
           
            // bottom hstack
            HStack{
                Image(uiImage: profileImage).resizable().scaledToFill().frame(width: 40,height: 40,alignment: .center).cornerRadius(20)
                TextField("Add a comment here", text: $submissionText)
                Button(action: {
                    print("bjfsf")
                    if textInAppropriate(){
                        
                        self.addComment()
                    }
                }, label: {
                    Image(systemName: "paperplane.fill").font(.title2)
                }).accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
            }.padding(.all,6)

        }
        .padding(.horizontal)
        .navigationBarTitle("Comments")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.getComments()
            self.getProfilePick()
        }
    }
    //MARK: FUNCTIONS
    
    func getProfilePick(){
        
        guard let _userId = currentUserId else{return}
        ImageManager.instance.downloadProfileImage(userId: _userId) { image in
            if let img = image{
                self.profileImage = img
            }
        }
    }
    func DeleteComment(isPostCaption:Bool) {
        
        if isPostCaption {
            post.caption = ""
        }
        self.commentArray.removeAll()
        getComments()
    }

    
    func textInAppropriate()->Bool{
        
        // check if the text has curses
        // check if the text is long enough
        // check if the text is blank
        // check for innappropriate
      
        // checking for bad word
        let badWordArray :[String] = ["shit","ass"]
        
        let words = submissionText.components(separatedBy: " ")
        
        for word in words {
            
            if badWordArray.contains(word){
                
                return false
            }
        }
        // checking for minimum character count

        if submissionText.count < 3{
            return false
        }
        return true

    }
    
    func addComment(){
        
        guard let _userId = currentUserId , let _displayName = displayName else{
            
            return
        }
        DataService.instance.uploadComment(postId: post.postId, content: submissionText, displayName: _displayName, UserId: _userId) { sucess, commentId in
            
            if sucess  , let _commentId = commentId{
                let newComment = CommentModel(commentID: _commentId, userId: _userId, userName: _displayName, content:submissionText , dateCreated: Date(), liked: false)
                self.commentArray.append(newComment)
                self.submissionText = ""
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                
            }
        }
    }
    
    func getComments(){
        print("get Comments From DataBase")
        guard self.commentArray.isEmpty else{return}
        
        if let caption = post.caption , caption.count > 1 {
            let captionComment = CommentModel(commentID: "", userId: post.userId, userName: post.userName, content: caption, dateCreated: post.dateCreated, liked: post.likedByUser)
            self.commentArray.append(captionComment)
        }
     
        DataService.instance.downloadComment(postId: post.postId) { returnComment in
            self.commentArray.append(contentsOf: returnComment)
        }
    }
}

struct CommentsView_Previews: PreviewProvider {
    
    @State static var deletedIndex : Bool = false
    static var previews: some View {
        NavigationView {

            CommentsView(post: PostModel(postId: "", userId: "", userName: "", dateCreated: Date(), likeCount: 0, likedByUser: false))
                .preferredColorScheme(.dark)
        }
    }
}
