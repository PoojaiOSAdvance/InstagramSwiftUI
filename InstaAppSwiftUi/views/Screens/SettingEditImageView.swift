//
//  SettingEditImageView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 30/03/23.
//

import SwiftUI

struct SettingEditImageView: View {
  
    @State var title : String
    @State var description : String
    @Binding var selectImage : UIImage // Image show in this screen
    @Binding var profileImg : UIImage // Image show in the profile
    @State var showImagePicker : Bool = false
    @State var showSucessAlert : Bool = false
    @State var sourceType : UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
    @Environment(\.presentationMode) var presentationMode
    @AppStorage(CurrentUserDefaults.userId)var userID :String?

    var body: some View {
        VStack(alignment: .leading,spacing: 20){
            HStack{
                Text(description)
                Spacer(minLength: 0)
            }

            Image(uiImage: selectImage)
                .resizable()
                .scaledToFill()
                .frame(width: 200,height: 200,alignment: .center)
                .clipped()
                .cornerRadius(12)
            

            Button(action: {
                self.updateUserProfile()
            }, label: {
                Text("SAVE")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.purpleColor)
                    .cornerRadius(12)
            })
            .accentColor(Color.MyTheme.yellowColor)
           
            Button(action: {
                
                showImagePicker.toggle()
                
            }, label: {
                Text("Import")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.yellowColor)
                    .cornerRadius(12)
            })
            .accentColor(Color.MyTheme.purpleColor)
            .sheet(isPresented: $showImagePicker,content:  {
                ImagePicker(selectedImage: $selectImage, sourceType: $sourceType)
            })
            
            Spacer()
        }.padding().frame(maxWidth: .infinity)
        .navigationBarTitle(title)
        .alert(isPresented: $showSucessAlert) {
            return Alert(title: Text("Successfully changed image!!! 😍"),message: nil,dismissButton: .default(Text("Ok"),action: {
                presentationMode.wrappedValue.dismiss()
            }))
        }
    }
    
    //MARK: FUNCTION
    
    func updateUserProfile(){
        
        // update UI  of the profile
        profileImg = selectImage
                
        
        //update profile in user Database
        guard let _userID = userID else{return}
        
        ImageManager.instance.uplaodProfileIamge(userID: _userID, image: selectImage)
        
        self.showSucessAlert.toggle()
    }
}

struct SettingEditImageView_Previews: PreviewProvider {
   
    @State static var selectImage : UIImage = UIImage(named: .logoLoading)!
    @State static var profileImg : UIImage = UIImage(named: .logoLoading)!

    static var previews: some View {
        NavigationView {
            SettingEditImageView(title: "Title", description: "description", selectImage: $selectImage, profileImg: $profileImg)

        }
    }
}
