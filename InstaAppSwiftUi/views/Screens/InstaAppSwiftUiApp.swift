//
//  InstaAppSwiftUiApp.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 27/03/23.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
@main
struct InstaAppSwiftUiApp: App {
    
    init(){
        FirebaseApp.configure()
        guard let clientID = FirebaseApp.app()?.options.clientID else { return } // FOR GOOGLE SIGNIN
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL(perform: { url in
                    GIDSignIn.sharedInstance.handle(url) // Google login
                })
        }
    }
}
