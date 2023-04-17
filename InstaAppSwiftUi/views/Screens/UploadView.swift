//
//  UploadView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 28/03/23.
//

import SwiftUI
import UIKit

struct UploadView: View {

    @State var showImagePicker : Bool = false
    @State var showPostImageView : Bool = false
    @State var selectedImage : UIImage = UIImage(named: String.logoTransparent)!
    @State var sourceType : UIImagePickerController.SourceType = .camera
    @Environment(\.colorScheme) var colorScheme
    @AppStorage(CurrentUserDefaults.userId) var currentUserId : String?
    @State var sendToOnboard : Bool = false
    

    var body: some View {
        ZStack {
            VStack(spacing: 0){
                Button(action: {
                    
                    if currentUserId != nil {
                       
                        sourceType = .camera
                        showImagePicker.toggle()

                    }
                    else{
                        sendToOnboard.toggle()
                    }
                    
                } , label: {
                    Text("Take Photo".uppercased()).font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.MyTheme.yellowColor)
                    
                })
                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
                .background(Color.MyTheme.purpleColor)
            
                Button(action: {
                    
                    if currentUserId != nil {
                       
                        sourceType = .photoLibrary
                        showImagePicker.toggle()

                    }
                    else{
                        sendToOnboard.toggle()

                    }
                    
                } , label: {
                    Text("Import Photo".uppercased()).font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color.MyTheme.purpleColor)
                    
                })
                .frame(maxWidth: .infinity,maxHeight: .infinity,alignment: .center)
                .background(Color.MyTheme.yellowColor)

            }
            .sheet(isPresented: $showImagePicker,onDismiss:segueToPostImageView,content:  {
                ImagePicker(selectedImage: $selectedImage, sourceType: $sourceType)
                    .preferredColorScheme(colorScheme)
                    .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
            
            })
            .fullScreenCover(isPresented: $sendToOnboard,onDismiss: nil, content: {
                
                OnboardingView()
            })

            Image(String.logoTransparent)
                .resizable()
                .scaledToFit()
                .frame(width: 100,height: 100,alignment: .center)
                .shadow(radius: 12)
                .fullScreenCover(isPresented: $showPostImageView,content: {
                    PostImageView(imageSelected: $selectedImage)
                        .preferredColorScheme(colorScheme)
                })
            
            
        }.edgesIgnoringSafeArea(.top)
          
    }
    
    //MARK: FUNCTIONS
    
    func segueToPostImageView(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            showPostImageView.toggle()
        }
    }
}

struct UploadView_Previews: PreviewProvider {
    static var previews: some View {
        UploadView()
            .preferredColorScheme(.light)
    }
}
