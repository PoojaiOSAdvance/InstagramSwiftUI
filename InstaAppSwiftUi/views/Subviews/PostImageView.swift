//
//  PostImageView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 29/03/23.
//

import SwiftUI

struct PostImageView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme 
    @State var captiontext : String = ""
    @Binding var imageSelected : UIImage
    @AppStorage(CurrentUserDefaults.userId) var userId : String?
    @AppStorage(CurrentUserDefaults.displayName) var displayName : String?
    @State var showAlert : Bool = false
    @State var postUploadedSucessfully : Bool = false


    var body: some View {
        VStack(alignment: .center,spacing: 0,content: {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.title)
                        .padding()
            }).accentColor(.primary)
                Spacer()
            }
            ScrollView(.vertical,showsIndicators: false,content: {
                
                Image(uiImage: imageSelected)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200,height:200 ,alignment: .center)
                    .cornerRadius(12)
                    .clipped()
                TextField("Add your caption here", text: $captiontext)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.MyTheme.beigeColor : Color.MyTheme.purpleColor)
                    .cornerRadius(12)
                    .font(.headline)
                    .padding(.horizontal)
                    .autocapitalization(.sentences)
                
                
              
                Button (action : {
                    postPicker()
                }, label: {
                    Text("Post Pickure!".uppercased())
                        .font(.title3)
                        .fontWeight(.bold)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)

                        .cornerRadius(12)
                        .padding(.horizontal)
                    

                }).accentColor(colorScheme == .light ? Color.MyTheme.yellowColor : Color.MyTheme.purpleColor)
                
            }).alert(isPresented: $showAlert) { () -> Alert in
                getAlert()
            }

        })
    }
    //MARK: FUNCTION
    
    func postPicker(){
        print("Post Picture To Database Here")
        
        guard let current_userd = userId , let curren_DisplayName = displayName else{
            
            print("ERROR GETTING USERID OR DISPLAYNAME WHILE POSTING IMAGE")
            return
        }
        
        DataService.instance.uploadPost(image: imageSelected, caption: captiontext, displayName: curren_DisplayName, userId: current_userd) { sucess in
            
            self.postUploadedSucessfully = sucess
            self.showAlert.toggle()
             
        }
    }
    
    func getAlert()->Alert{
        
        if postUploadedSucessfully {
            return Alert(title: Text("Successfully upload post! 🥳"),message: nil,dismissButton: .default(Text("OK"),action: {
                
                self.presentationMode.wrappedValue.dismiss()
            }))
        }
        else{
            return Alert(title: Text("Error uploading post! 🙁"))

        }
    }
}

struct PostImageView_Previews: PreviewProvider {
    @State static var selectedImage = UIImage(named: "dog1")!

    static var previews: some View {
        
        PostImageView(imageSelected:$selectedImage).preferredColorScheme(.light)
    }
}
