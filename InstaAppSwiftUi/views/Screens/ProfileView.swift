//
//  ProfileView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 29/03/23.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var profileImage : UIImage = UIImage(named: .logoLoading)!
    @State var profileDisplayName : String
    @State var profileBio : String = ""
    @State var feeback : String = ""

    var profileUserId : String
    var isMyProfile : Bool
    var postArrayObj  : PostArrayObject
    @State var showSettings : Bool = false
    
    
    var body: some View {
        ScrollView(.vertical,showsIndicators: false,content: {
            ProfileHeaderView(profileImage: $profileImage, profileDisplayName: $profileDisplayName, postArrayObj: postArrayObj, profileBio: $profileBio)
            Divider()
            ImageGridView(postArrayObj: postArrayObj)
        })
        .navigationBarTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing:Button(action: {
            showSettings.toggle()
        }, label: {
            Image(systemName: "line.horizontal.3")
            
        }).accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
            .opacity(isMyProfile ? 1.0 : 0.0)
        )
        .onAppear(perform: {
            getProfileImage()
        })
        .sheet(isPresented: $showSettings) {
            SettingsView(user_DisplayName: $profileDisplayName, user_Bio: $profileBio,feedback: feeback, profileImage: $profileImage)
                .preferredColorScheme(colorScheme)
        }
        .onAppear {
            getAdditionalProfileInfo()
        }
    }
    
    //MARK: FUNCTIONS
    
    func getProfileImage(){
        
        ImageManager.instance.downloadProfileImage(userId: profileUserId) { image in
            if let _image = image{
                
                print("get Downloaded in cache")
                
                self.profileImage = _image
            }
        }
    }
    func getAdditionalProfileInfo(){
        
        AuthService.instance.getUserInfo(forUserId: profileUserId) { name, bio in
            
            if let _name = name{
                
                profileDisplayName = _name
            }
            
            if let _bio = bio{
                
                profileBio = _bio
            }
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    @State static var profileDisName : String = "Pooja"
    @State static var isMyProfile : Bool = true
    
    static var previews: some View {
        NavigationView {
            ProfileView(profileDisplayName: profileDisName, profileUserId: "", isMyProfile: isMyProfile, postArrayObj: PostArrayObject(userId: ""))
                .preferredColorScheme(.dark)
        }
    }
}
