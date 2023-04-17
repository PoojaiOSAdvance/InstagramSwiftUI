//
//  ProfileHeaderView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 29/03/23.
//

import SwiftUI

struct ProfileHeaderView: View {
    
    @Binding var profileImage : UIImage
    @Binding var profileDisplayName : String
    @ObservedObject var postArrayObj :PostArrayObject
    @Binding var profileBio : String
    
    var body: some View {
        VStack(alignment: .center,spacing: 10,content: {
            //MARK: Profile Picture
            Image(uiImage: profileImage)
                .resizable()
                .scaledToFill()
                .frame(width: 120,height: 120,alignment: .center)
                .cornerRadius(60)
            
            //MARK: UserName

            Text(profileDisplayName).font(.largeTitle).fontWeight(.bold)
            
            //MARK: User Bio
            if profileBio != ""{
             
                Text(profileBio)
                    .font(.body)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)

            }
                        
            //MARK: Likes

            HStack(alignment: .center,spacing: 20, content: {
            
                //MARK: Post
                VStack(alignment: .center,spacing: 5, content: {
                    Text(postArrayObj.postCountString).font(.title2).fontWeight(.bold)
                    Capsule().fill(Color.gray)
                        .frame(width: 20,height: 2,alignment: .center)
                    
                    Text("Posts").font(.callout).fontWeight(.medium)
                })

                //MARK: likes

                VStack(alignment: .center,spacing: 5, content: {
                    Text(postArrayObj.likeCountString).font(.title2).fontWeight(.bold)
                    Capsule().fill(Color.gray)
                        .frame(width: 20,height: 2,alignment: .center)
                    
                    Text("Likes").font(.callout).fontWeight(.medium)
                })
            })

        }).frame(maxWidth: .infinity).padding()
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    @State static var name : String = "Pooja"
    @State static var bio : String = ""
    @State static var image : UIImage =  UIImage(named: "dog1")!

    static var previews: some View {
        ProfileHeaderView(profileImage: $image, profileDisplayName: $name, postArrayObj: PostArrayObject(shuffled: false), profileBio: $bio).previewLayout(.sizeThatFits)
    }
}
