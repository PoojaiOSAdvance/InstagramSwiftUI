//
//  MessageView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 28/03/23.
//

import SwiftUI

protocol OnActionRefresh {
    
    func DeleteComment(isPostCaption:Bool)
}


struct MessageView: View {
    
    @State var comment : CommentModel
    @State var profileImage : UIImage = UIImage(named: .logoLoading)!
    @Binding var isMoreShow : Bool
    @State var islike : Bool = false
    @Binding var isDelete : Bool
    @Binding var islikeReq : Bool
    @State var addHeartAnimationToView : Bool = false
    @State var addDeleteAnimationToView : Bool = false
    @Binding var likeAnimation : Bool
    @State var dissLikeAnimation : Bool = false
    @State var deleteAnimation : Bool = false
    @Binding var row : String
    @AppStorage(CurrentUserDefaults.userId) var currentUserId : String?
    @State var post : PostModel
    
    var delegate : OnActionRefresh?


    var body: some View {
        
        HStack{
            //MARK: User Profile
            NavigationLink(destination: {
                LazzyView {
                    ProfileView(profileDisplayName: comment.userName, profileUserId: comment.userId, isMyProfile: false, postArrayObj: PostArrayObject(userId: comment.userId))
                }
            },
            
            label: {
                Image(uiImage:profileImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40,alignment: .center)
                    .cornerRadius(20)
            })
            
            VStack(alignment: .leading,spacing:4,content:  {
              
                //MARK: User Name
                Text(comment.userName).font(.caption).foregroundColor(.gray)
                
                //MARK:Comment Content
                HStack {
                    
                    Text(comment.content)
                        .padding(.all,10)
                        .foregroundColor(.primary)
                        .background(Color.gray)
                    .cornerRadius(10)

                    
                    // more view for  Like Comments
                  
                    if ((row == "\(comment.id)")) && isMoreShow  {
                        
                        Button(action: {
                            
                            row = ""
                            isDelete.toggle()
                            islike = true
                            
                            
                        }, label: {
                            isMoreShow  ?  Image(systemName: "ellipsis") :  Image(systemName: "")
                            
                        })
                        .accentColor(.primary)
                        
                        
                    }
                    
                    if islike || ((row == "\(comment.id)") && islikeReq){
                        Button(action: {
                            row = ""

                           if likeAnimation  || comment.liked {
                                
                                disLike()
                            }
                            else{
                              like()
                                
                            }
                            
                        }, label: {
                            
                            Image(systemName: likeAnimation ? "heart.fill" : comment.liked ? "heart.fill" : "heart")
                                .foregroundColor(likeAnimation ? .red : comment.liked ? .red : .primary)
                        })
                        
                    }
                    
                    if  ((row == "\(comment.id)")) && isDelete {
                        Button(action: {
                            row = ""
                            
                            self.deleteComment()

                            
                        }, label: {
                            
                            Image(systemName:"trash")
                                .foregroundColor(.primary)
                        })
                        
                    }

                }
               
                if addHeartAnimationToView{
                    LikeAnimationView(animate: $likeAnimation, dissLike: $dissLikeAnimation)
                }
                if addDeleteAnimationToView{
                    DeleteAnimationView(animate: $deleteAnimation)
                }

            })
            Spacer(minLength: 0)
        }
        .onAppear {
            getProfileImage()
        }
    }
    
    //MARK: FUNCTION
    
    func like(){

        addHeartAnimationToView = true
        likeAnimation.toggle()
        dissLikeAnimation = false
        comment.liked = true
        islike = true

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7, execute: {
            addHeartAnimationToView = false
        })
        
        guard let _currentUserID = currentUserId else{return}
        
        if comment.commentID == ""{
            
            //Update local data
            let updatedPost = PostModel(postId: post.postId, userId: post.userId, userName: post.userName,caption: post.caption, dateCreated: Date(), likeCount: (post.likeCount + 1), likedByUser: true)
            self.post = updatedPost
           
            comment.liked = true

            // update Database
            DataService.instance.likePost(postId: post.postId, currentUserID: _currentUserID)

        }
        else{
                    
            DataService.instance.likePostComment(postId: post.postId, currentUserID: _currentUserID, commentId: comment.commentID)
        }

    }
    
    func disLike(){
        
        addHeartAnimationToView = false
        likeAnimation = false
        comment.liked = false
        

        guard let _currentUserID = currentUserId else{return}
        
        if comment.commentID == ""{
            
            //Update local data
            let updatedPost = PostModel(postId: post.postId, userId: post.userId, userName: post.userName,caption: post.caption, dateCreated: Date(), likeCount: (post.likeCount + 1), likedByUser: true)
            self.post = updatedPost
            comment.liked = false

            // update Database
            DataService.instance.unLikePost(postId: post.postId, currentUserID: _currentUserID)

        }
        else{
                    
            DataService.instance.unLikePostComment(postId: post.postId, currentUserID: _currentUserID, commentId: comment.commentID)
        }

    }
    
    func deleteComment(){
        
        // Apply animation
        addDeleteAnimationToView.toggle()
        deleteAnimation = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            addDeleteAnimationToView = false
            deleteAnimation = false
            
        })
        
        // local delete
        
        isMoreShow = false
        islike = false
        isDelete = false
        
        guard let _delegate = delegate else{return}
        
        //delete from database

        if comment.commentID == "" {
            
            DataService.instance.removeCaptionOnPosts(postID: post.postId) { success in
                _delegate.DeleteComment(isPostCaption: true)
            }
        }
        else{
            
            DataService.instance.deleteComments(postId: post.postId, commentId: comment.commentID, handler: { success in
                if success{
                    
                    _delegate.DeleteComment(isPostCaption: false)
                    
                }
            })

        }
        
    }
        
            
    func getProfileImage(){
        
        ImageManager.instance.downloadProfileImage(userId: comment.userId) { image in
            if let img = image{
                
                self.profileImage = img
            }
        }
    }
}

struct MessageView_Previews: PreviewProvider {
    static var commentModel : CommentModel = CommentModel(commentID: "", userId: "", userName: "Pooja", content: "This is really nice", dateCreated: Date(), liked: false)
    
    @State static var row : String = ""
    @State static var isMoreShow : Bool = false
    
    
    static var previews: some View {
        MessageView(comment: commentModel,isMoreShow: $isMoreShow,islike:isMoreShow, isDelete: $isMoreShow, islikeReq: $isMoreShow, likeAnimation: $isMoreShow, row: $row, post: PostModel(postId: "", userId: "", userName: "", dateCreated: Date(), likeCount: 0, likedByUser: false))
            .previewLayout(.sizeThatFits)
    }
}
