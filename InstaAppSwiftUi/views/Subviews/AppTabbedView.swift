//
//  AppTabbedView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 29/03/23.
//

import SwiftUI

struct AppTabbedView: View ,onRefreshPost {
 
    func onDeletePost() {
        feedPosts = PostArrayObject(shuffled: false)
    }
    

    @Environment(\.colorScheme) var colorScheme
    @State private var selectionId = 0
    @AppStorage(CurrentUserDefaults.userId) var currentUserId : String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName : String?

    @State var feedPosts : PostArrayObject = PostArrayObject(shuffled: false)
    let browsePosts = PostArrayObject(shuffled: true)
    init() {
        UITabBar.appearance().backgroundColor = UIColor.systemGroupedBackground
    }
    
    var body: some View {
        TabView(selection: $selectionId, content:{
           
            NavigationView {
                FeedView(postArrayObj: feedPosts, title: "FEED",delegate: self)
            }
            .tabItem {
                Image(systemName: "book.fill")
                Text("Feed")
            }.tag(0)
            NavigationView {
                BrowseView(postArrayObj: browsePosts)
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
                Text("Browse")
            }.tag(1)
            
             UploadView()
                .tabItem {
                    Image(systemName: "square.and.arrow.up.fill")
                    Text("Upload")
                }.tag(2)
           
            ZStack {
              
                if let _userId = currentUserId ,let _displayName =  displayName {
                    NavigationView {
                        ProfileView(profileDisplayName: _displayName, profileUserId: _userId ,isMyProfile: true, postArrayObj: PostArrayObject(userId: _userId))
                    }
                }
                else{
                    NavigationView {
                        SignupView()
                    }

                }
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("Profile")
            }.tag(3)
            
        })

        .accentColor( colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
    }
}

struct AppTabbedView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabbedView()
            .preferredColorScheme(.dark)
    }
}
