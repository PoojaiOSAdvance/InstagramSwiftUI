//
//  DataService.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 05/04/23.
//

// TO HANDLE UPLOADING AND DOWNLOADING OTHER THAN DATABASE

import Foundation
import SwiftUI
import FirebaseFirestore // Database

class DataService{
    
    //MARK: PROPERTIES
    
    static let instance = DataService()
    private var REF_POSTS = DB_BASE.collection("posts")
    private var REF_REPORTS = DB_BASE.collection("reports")
    private var REF_FEEDBACK = DB_BASE.collection("feedback")

    @AppStorage(CurrentUserDefaults.userId) var currentUserID :String?
    
    
    //MARK: CREATE FUNCTIONS
    
    func uploadPost(image:UIImage,caption:String?,displayName:String,userId:String,handler:@escaping(_ sucess:Bool)->()){
        
        //create new post document
        
        let document = REF_POSTS.document()
        let postID = document.documentID
        
        // upload image to storage
        
        ImageManager.instance.uploadPostImage(postId: postID, image: image) { sucess in
            
            if sucess{
                let postData :[String:Any] = [
                    
                    DataBasePostFeild.postId : postID,
                    DataBasePostFeild.userID : userId,
                    DataBasePostFeild.caption : caption,
                    DataBasePostFeild.displayName : displayName,
                    DataBasePostFeild.dateCreated : FieldValue.serverTimestamp()
                    
                ]
                
                print("SUCESS for UPLoAD POST IMAGE Data now upload post data into Database")
                document.setData(postData) { error in
                    if let _error = error{
                        print("ERORR uploading data to post document\(_error)")
                        handler(false)
                        return
                    }
                    else{
                        handler(true)
                        return
                    }
                }
            }
            else{
                print("ERROR for UPLoAD POST IMAGE to firebase")
                handler(false)
                return
            }
            
        }
    }
    
    //MARK: COMMENTS
    
    func uploadComment(postId:String,content:String,displayName:String,UserId:String,handler:@escaping(_ sucess:Bool,_ commentId:String?)->()){
        
        let documet = REF_POSTS.document(postId).collection(DataBasePostFeild.comments).document()
        let commentId = documet.documentID
        
        let data :[String:Any] = [
            DataBaseCommentsFeild.commentId :commentId,
            DataBaseCommentsFeild.userID :UserId,
            DataBaseCommentsFeild.content :content,
            DataBaseCommentsFeild.displayName :displayName,
            DataBaseCommentsFeild.dateCreated :FieldValue.serverTimestamp(),
            DataBaseCommentsFeild.postId :postId,
            DataBaseCommentsFeild.liked :false
        ]
        
        documet.setData(data) { (error) in
            
            if let _error = error{
                print("ERROR WHILE UPLOADING COMMENTS \(_error)")
                handler(false,nil)
                return
            }
            else{
                handler(true,commentId)
                return
            }
        }
    }
    
    func deleteComments(postId:String,commentId:String,handler:@escaping(_ success:Bool) -> ()){
      
        let documet = REF_POSTS.document(postId).collection(DataBasePostFeild.comments).document(commentId)

        documet.delete()
        
        handler(true)
        
    }
    
    //MARK: uploadReports FUNCTIONS
    
    func uploadReport(reason:String,postId:String,handler:@escaping(_ success:Bool)->()){
        
        let data :[String:Any] = [
            
            DataBaseReportFeild.content :reason,
            DataBaseReportFeild.postId :postId,
            DataBaseReportFeild.dateCreated : FieldValue.serverTimestamp()
            
        ]
        
        REF_REPORTS.addDocument(data: data) { error in
            
            if let _error =  error {
                
                print("ERROR WHILE UPLOADING REPORT \(_error)")
                handler(false)
            }
            else{
                print("SUCCESSFULLY UPLOADING REPORT")
                handler(true)
                
            }
        }
        
    }
    
    //MARK: uploadFeedback FUNCTIONS
    
    func uploadFeedback(title:String,subTitle:String,userId:String,handler:@escaping(_ success:Bool)->()){
        
     
        let data :[String:Any] = [
            
            DataBaseFeedBackFeild.userID :userId,
            DataBaseFeedBackFeild.title :title,
            DataBaseFeedBackFeild.subTitle : subTitle,
            DataBaseFeedBackFeild.dateCreated : FieldValue.serverTimestamp()
        ]
        
        REF_FEEDBACK.addDocument(data: data) { error in
            
            if let _error =  error {
                
                print("ERROR WHILE UPLOADING FEEDBACK \(_error)")
                handler(false)
            }
            else{
                print("SUCCESSFULLY UPLOADING FEEDBACK")
                handler(true)
                
            }
        }
        
    }

    
    
    //MARK: get FUNCTIONS
    func downloadComment(postId:String,hanlder:@escaping([CommentModel])->()){
        
        REF_POSTS.document(postId).collection(DataBasePostFeild.comments).order(by: DataBaseCommentsFeild.dateCreated, descending: false).getDocuments { querySnapshot, error in
            
            print("SuccesFully DOWNLOAD COMMENTS")
            
            hanlder(self.getComments(querySnapshot: querySnapshot))
        }
    }
    
    private func getComments(querySnapshot:QuerySnapshot?)->[CommentModel]{
        
        var commentArray = [CommentModel]()
        
        if let snapshot = querySnapshot,snapshot.count > 0{
            
            for  document in snapshot.documents{
                if let userId = document.get(DataBaseCommentsFeild.userID) as? String,
                   let  displayName = document.get(DataBaseCommentsFeild.displayName) as? String,
                   let content = document.get(DataBaseCommentsFeild.content) as? String,
                   let timeStamp = document.get(DataBaseCommentsFeild.dateCreated) as? Timestamp
                {
                    
                    let commentId = document.documentID
                    let date = timeStamp.dateValue()
                    let liked = document.get(DataBaseCommentsFeild.liked) as? Bool ?? false
                    let newComment = CommentModel(commentID: commentId, userId: userId, userName: displayName, content: content, dateCreated: date, liked: liked)
                    
                    commentArray.append(newComment)
                    
                }
            }
            return  commentArray
            
        }
        else{
            print("No comments in document for this post")
            return commentArray
        }
        
    }
    func downloadPostForUser(userId:String,hanlder:@escaping(_ posts:[PostModel])->()){
        
        REF_POSTS.whereField(DataBasePostFeild.userID, isEqualTo: userId).getDocuments { (querySnapshot, error) in
            
            hanlder(self.getPostsFromSnaoshot(querySnapshot: querySnapshot))
            
        }
        
    }
    
    
    func getPostByPostIdLikeByUser(postId:String,userId:String,handler:@escaping((Bool) ->())){
        
        REF_POSTS.order(by: DataBasePostFeild.dateCreated, descending: true).limit(to: 50).getDocuments { querySnapshot, error in
            
            handler(self.getPostsById(postID: postId, userID: userId, querySnapshot: querySnapshot))
            
        }
    }

    func downloadPostforFeed(hanlder:@escaping(_ posts:[PostModel])->()){
        
        REF_POSTS.order(by: DataBasePostFeild.dateCreated, descending: true).limit(to: 50).getDocuments { querySnapshot, error in
            
            hanlder(self.getPostsFromSnaoshot(querySnapshot: querySnapshot))
            
        }
    }
    
    private func getPostsFromSnaoshot(querySnapshot:QuerySnapshot?) -> [PostModel]{
        
        var postArray = [PostModel]()
        
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            
            for document in snapshot.documents{
                
                
                if  let userId =  document.get(DataBasePostFeild.userID) as? String,
                    let displayName = document.get(DataBasePostFeild.displayName) as? String,
                    let dateCreated = document.get(DataBasePostFeild.dateCreated) as? Timestamp
                {
                    let caption  = document.get(DataBasePostFeild.caption) as? String
                    let date = dateCreated.dateValue()
                    let postId =  document.documentID
                    let likeCount = document.get(DataBasePostFeild.likeCount) as? Int ?? 0
                    var likeByUser = false
                    
                    if let userIDArray = document.get(DataBasePostFeild.likedBy) as? [String],let _userId = currentUserID {
                        
                        likeByUser = userIDArray.contains(_userId)
                        
                    }
                    
                    let newPost = PostModel(postId: postId, userId: userId, userName: displayName,caption: caption,dateCreated: date, likeCount: likeCount, likedByUser: likeByUser)
                    postArray.append(newPost)
                }
            }
            
            return(postArray)
        }
        else{
            print("NO DOCUMNETS IN SNAPSHOTS FOUND FOR THIS USER")
            return(postArray)
        }
        
    }
    
    private func getPostsById(postID:String,userID:String,querySnapshot:QuerySnapshot?) -> Bool{
        
        
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            
            var likeByUser = false

            for document in snapshot.documents{
               
                if let userIDArray = document.get(DataBasePostFeild.likedBy) as? [String],postID == document.documentID {
                    
                    likeByUser = userIDArray.contains(userID)
                    
                    return likeByUser
                }
            }
            
        }
        else{
            print("NO DOCUMNETS IN SNAPSHOTS FOUND BY post id")
        }
        
        return false

    }
    
    
    
    //MARK: update FUNCTIONS ExistingDocument
    
    func likePost(postId:String,currentUserID:String){
        
        //Update the Post Count
        //Update the Array user who liked the Post
        let increment : Int64 =  1
        let data : [String:Any] = [
            
            DataBasePostFeild.likeCount : FieldValue.increment(increment),
            DataBasePostFeild.likedBy : FieldValue.arrayUnion([currentUserID])
        ]
        
        REF_POSTS.document(postId).updateData(data)
    }
    
    func unLikePost(postId:String,currentUserID:String){
        
        //Update the Post Count
        //Update the Array user who liked the Post
        let increment : Int64 =  -1
        let data : [String:Any] = [
            
            DataBasePostFeild.likeCount : FieldValue.increment(increment),
            DataBasePostFeild.likedBy : FieldValue.arrayRemove([currentUserID])
        ]
        
        REF_POSTS.document(postId).updateData(data)
    }
    
    
    func updateDisplayNameOnPosts(userId:String,displayName:String){
        
        downloadPostForUser(userId: userId) { returnPost in
            for post in returnPost{
                
                self.updatePostDisplayName(postId: post.postId, displayName: displayName)
                
            }
        }
    }
    
    private func updatePostDisplayName(postId:String,displayName:String) {
        
        let data :[String:Any] = [
        
            DataBasePostFeild.displayName : displayName
        ]
        REF_POSTS.document(postId).updateData(data)
    }
    
    
    // MARK: remove caption  on POST
    
    func removeCaptionOnPosts(postID:String,handler:@escaping((_ success :Bool)->())){
        
        let data :[String:Any] = [
        
            DataBasePostFeild.caption : ""
        ]
        REF_POSTS.document(postID).updateData(data)
        
        handler(true)

    }
    
    
    //MARK: update FUNCTIONS Existing Comment
    
  
    func likePostComment(postId:String,currentUserID:String,commentId:String){
        
        
        //Update the Post Count
        //Update the Array user who liked the Post
        let increment : Int64 =  1
        let data : [String:Any] = [
            
            DataBaseCommentsFeild.liked : FieldValue.increment(increment),
            DataBaseCommentsFeild.likedBy : FieldValue.arrayUnion([currentUserID])
        ]
        
        let documet = REF_POSTS.document(postId).collection(DataBasePostFeild.comments).document(commentId)

        documet.updateData(data)
        
        
    }
    
    func unLikePostComment(postId:String,currentUserID:String,commentId:String){
        
        //Update the Post Count
        //Update the Array user who liked the Post
        let increment : Int64 =  -1
        let data : [String:Any] = [
            
            DataBaseCommentsFeild.liked : FieldValue.increment(increment),
            DataBaseCommentsFeild.likedBy : FieldValue.arrayRemove([currentUserID])
        ]
        
        let documet = REF_POSTS.document(postId).collection(DataBasePostFeild.comments).document(commentId)
        documet.updateData(data)

    }

    
    //MARK: GET UPDATED POST TO REFRESH
    
    func getPostByPostID(postId:String,userId:String,handler:@escaping((PostModel?) ->())){
        
        REF_POSTS.getDocuments { querySnapshot, error in
            
            handler(self.getUpdatedPostsById(postID: postId, userID: userId, querySnapshot: querySnapshot))
        }
    }

    private func getUpdatedPostsById(postID:String,userID:String,querySnapshot:QuerySnapshot?) -> PostModel?{
        
                
        if let snapshot = querySnapshot, snapshot.documents.count > 0 {
            
            for document in snapshot.documents{
                
                
                if  let userId =  document.get(DataBasePostFeild.userID) as? String,
                    let displayName = document.get(DataBasePostFeild.displayName) as? String,
                    let dateCreated = document.get(DataBasePostFeild.dateCreated) as? Timestamp ,
                    postID == document.documentID
                {
                    let caption  = document.get(DataBasePostFeild.caption) as? String
                    let date = dateCreated.dateValue()
                    let likeCount = document.get(DataBasePostFeild.likeCount) as? Int ?? 0
                    var likeByUser = false
                    
                    if let userIDArray = document.get(DataBasePostFeild.likedBy) as? [String],let _userId = currentUserID {
                        
                        likeByUser = userIDArray.contains(_userId)
                        
                    }
                    
                    let newPost = PostModel(postId: postID, userId: userId, userName: displayName,caption: caption,dateCreated: date, likeCount: likeCount, likedByUser: likeByUser)
                    return newPost
                }
            }
            
        }
        else{
            print("NO DOCUMNETS IN SNAPSHOTS FOUND FOR THIS USER")
            return nil
        }
        return nil


    }

    
    //MARK: Delete post
    
    func deletePost(postId:String, handler:(_ Success:Bool)->()){
        
        let documet = REF_POSTS.document(postId)
        
        documet.delete()
        
         
        handler(true)
        
    }

}
