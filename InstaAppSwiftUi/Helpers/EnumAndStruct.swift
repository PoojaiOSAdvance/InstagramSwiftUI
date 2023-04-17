//
//  EnumAndStruct.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 04/04/23.
//

import Foundation

struct DatabaseUserField{ //THIS IS THE FEILD USER DOCUMENTS IN DATABASE
    
    static let displayName = "display_name"
    static let email = "email"
    static let providerId = "provider_id"
    static let provider = "provider"
    static let userId = "user_id"
    static let bio = "bio"
    static let dateCreated = "date_created"
}

struct CurrentUserDefaults { //THIS IS THE FEILD USER DOCUMENTS IN Userdefault
    
    static let displayName = "display_name"
    static let userId = "user_id"
    static let bio = "bio"
}


struct DataBasePostFeild { //THIS IS THE FEILD USER DOCUMENTS IN Userdefault
    
    static let postId = "postId"
    static let userID = "userID"
    static let displayName = "display_name"
    static let caption = "caption"
    static let dateCreated = "dateCreated"
    static let likeCount = "like_count" // Int
    static let likedBy = "liked_By" // Array
    static let comments = "comments" // sub-collection

}

struct DataBaseReportFeild { //THIS IS THE FEILD REPORTS DOCUMENTS IN Database
    
    static let content = "content"
    static let postId = "postId"
    static let dateCreated = "dateCreated"
    
}

struct DataBaseCommentsFeild { //THIS IS THE FEILD Comments subcollection posts DOCUMENTS IN Database
    
    static let content = "content"
    static let displayName = "display_name"
    static let commentId = "comment_Id" // sub-collection
    static let userID = "userID"
    static let dateCreated = "dateCreated"
    static let postId = "postId"
    static let liked = "like_count"
    static let likedBy = "liked_By" // Array

}

struct DataBaseFeedBackFeild { //THIS IS THE FEILD For Feedback subcollection posts DOCUMENTS IN Database
    
    static let title = "title"
    static let subTitle = "subTitle"
    static let userID = "userID"
    static let dateCreated = "dateCreated"
}


enum SettingEditTextOption{
    
    case displayName
    case bio
    case feedback

}
