//
//  AnalyaticsService.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 07/04/23.
//

import Foundation
import FirebaseAnalytics


class AnalyaticsService{
    
    static let instance = AnalyaticsService()
    
    func likePostDoubleTap(){
        
        Analytics.logEvent("like_double_tap", parameters: nil)
        
    }
    
    func likePostHeartPressed(){
        Analytics.logEvent("like_double_clicked", parameters: nil)

    }
    
}
