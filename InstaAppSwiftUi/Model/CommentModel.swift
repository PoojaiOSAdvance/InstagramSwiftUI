//
//  CommentModel.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 28/03/23.
//

import Foundation
import SwiftUI

struct CommentModel : Identifiable,Hashable{
    var id = UUID()
    var commentID : String //  id for the comment in database
    var userId : String // id for the user in database
    var userName :String // name for the user in database
    var content :String // Actully comment text
    var dateCreated :Date //comment date
    var liked :Bool //comment date

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
