//
//  Extension.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 27/03/23.
//

import Foundation
import SwiftUI

extension Color{
   
    struct MyTheme {
        
        static var purpleColor : Color{
            return Color("purpleColor")
        }
       
        static var yellowColor : Color{
            return Color("yellowColor")
        }
        static var beigeColor : Color{
            return Color("beigeColor")
        }

    }
}

extension String{
    
    static var logoTransparent :String{
        return "logo.transparent"
    }
    static var logoLoading :String{
        return "logo.loading"
    }

}


enum PostActionSheetOption{
    case general
    case reported
    case PersonalPostRelated
}



enum AlertType{
    
    case OnFailure
    case OnSuccess
}
