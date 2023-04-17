//
//  PostModel.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 27/03/23.
//

import Foundation
import SwiftUI

struct PostModel :Identifiable,Hashable{
    var id = UUID()
    var postId :String // for the post in DataBase
    var userId :String // for the User in DataBase
    var userName :String // userName of User in DataBase
    var caption : String?
    var dateCreated :Date
    var likeCount : Int
    var likedByUser :Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
