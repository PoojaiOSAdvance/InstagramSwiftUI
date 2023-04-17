//
//  PostArrayObject.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 27/03/23.
//

import Foundation

class PostArrayObject : ObservableObject{
    
    @Published var dataArray = [PostModel]()
    @Published var postCountString = "0"
    @Published var likeCountString = "0"
    
    
    //USED FOR SINGLE SELECTION
    init(post:PostModel){
        self.dataArray.append(post)
    }
    
    //USED FOR Getting post for user profile
    
    init(userId:String){
        
        print("GET POSTS FOR userId\(userId)")
        
        DataService.instance.downloadPostForUser(userId: userId) { returnPosts in
            let sortedPosts =  returnPosts.sorted { post1, post2 in
                return post1.dateCreated > post2.dateCreated
            }
            
            self.dataArray.append(contentsOf: sortedPosts)
            self.updateCount()
        }
    }
    
    // FOR FEED DATA
    
    init(shuffled:Bool){
        
        print("GET POSTS FOR FEED\(shuffled)")
        DataService.instance.downloadPostforFeed { returnPosts in
            if shuffled {
                let shuffledPosts = returnPosts.shuffled()
                self.dataArray.append(contentsOf: shuffledPosts)
            }
            else{
                self.dataArray.append(contentsOf: returnPosts)
            }
        }
        
    }
    
    //MARK: FUNCTION
    
    func updateCount(){
        
        self.postCountString = "\(self.dataArray.count)"
        let likeCountArray = dataArray.map {(existingPost) -> Int in
            
            return existingPost.likeCount
        }
        let sumOfLikeCountArray = likeCountArray.reduce(0,+)
       
        self.likeCountString = "\(sumOfLikeCountArray)"
        
    }
}
