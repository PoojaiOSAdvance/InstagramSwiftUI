//
//  SettingView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 29/03/23.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presenationMode
    @State var showError :Bool = false
   
    @Binding var user_DisplayName :String
    @Binding var user_Bio :String
    @State var feedback :String = "Enter your feed back"
    @Binding var profileImage : UIImage

    var body: some View {
        NavigationView{
            ScrollView(.vertical,showsIndicators: false,content:{
                //MARK: SECTION 1 : DOGGRAM
                GroupBox(label: SettingsLableView(lableText: "DogGram", lableImage: "dot.radiowaves.left.and.right"),content:{
                    HStack(alignment: .center,spacing: 10, content: {
                        Image(String.logoTransparent).resizable().scaledToFit()
                            .frame(width: 80,height: 80,alignment: .center).cornerRadius(12)
                        Text("DogGram is the #1 app for posting pictures of your dog and sharing them across the world. We are the dog loving community and we are happy to have you")
                            .font(.footnote)
                    })
                    
                }).padding()
                
                //MARK: SECTION 2 : PROFILE
                GroupBox(label: SettingsLableView(lableText: "Profile", lableImage: "person.fill"),content:{
                    NavigationLink (destination:SettingsEditTextView(submissionText:user_DisplayName,title: "Display Name", description: "You can add your display name this will be seen by other users on your profile and on your posts!", placeholder: "Your display name here ...",settingEditTextOption: .displayName,profileText: $user_DisplayName), label: {
                        SettingRowView(leftIcon: "pencil", text: "DisplayName", color: Color.MyTheme.purpleColor)
                        
                    })
                    
                    NavigationLink (destination:SettingsEditTextView(submissionText:user_Bio,title: "Profile Bio", description: "Your bio is greate place ,to let other know about you.It will be shown on your profile only. ", placeholder: "Your bio here ...",settingEditTextOption: .bio, profileText: $user_Bio), label: {
                        
                        SettingRowView(leftIcon: "text.quote", text: "Bio", color: Color.MyTheme.purpleColor)
                        
                    })
                    
                    NavigationLink (destination:SettingFeedBackView(feebackSubTitle: "Enter your feed back",selectedTitle: $feedback, feebackTitle: "Select your feed type",bottomIcon: "chevron.down.circle",color: .primary), label: {
                        
                        SettingRowView(leftIcon: "rectangle.and.pencil.and.ellipsis", text: "Feedback", color: Color.MyTheme.purpleColor)
                        
                    })

                    NavigationLink (destination:SettingEditImageView(title: "Profile Picture", description: "Your profile picture will be shown to your profile and on your posts. most of the users make it as an image of themseleves or of their dog!", selectImage: $profileImage,profileImg: $profileImage), label: {
                        
                        SettingRowView(leftIcon: "photo", text: "Profile picture", color: Color.MyTheme.purpleColor)
                    })
                    
                    Button(action: {
                        signOut()
                    }, label: {
                        
                        SettingRowView(leftIcon: "figure.walk", text: "Sign out", color: Color.MyTheme.purpleColor)
                    }).alert(isPresented: $showError,content: {
                        return Alert(title: Text("Error SignIn out😌"))
                    })
                    
                }).padding()
                
                //MARK: SECTION 3 : Application
                
                GroupBox(label: SettingsLableView(lableText: "Application", lableImage: "apps.iphone"),content:{
                    
                    Button (action:{
                        openCustomUrl(urlString: "https://www.yahoo.com/")
                    }, label: {
                        SettingRowView(leftIcon: "folder.fill", text: "Privacy Policy", color: Color.MyTheme.yellowColor)
                    })
                    
                    Button (action:{
                        openCustomUrl(urlString: "https://www.youtube.com/")
                        
                    }, label: {
                        SettingRowView(leftIcon: "folder.fill", text: "Terms & Conditions", color: Color.MyTheme.yellowColor)
                    })
                    
                    Button (action:{
                        openCustomUrl(urlString: "https://www.google.com/")
                        
                    }, label: {
                        SettingRowView(leftIcon: "globe", text: "DogGram's website", color: Color.MyTheme.yellowColor)
                    })
                    
                    
                }).padding()
                
                //MARK: SECTION 3 : Signoff
                
                GroupBox(content:{
                    Text("DogGram was made with love. \n All Rights Reserved \n Cool Apps Inc. \n Copy Right 2023❤️")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                }).padding()
                    .padding(.bottom,80)
                
                
                
            }).navigationBarTitle("Settings")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarItems(leading:
                                        Button(action: {
                    presenationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "xmark")
                        .font(.title3)
                }).accentColor(.primary)
                )
            Spacer()
            
        }
        .accentColor(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
    }
    
    //MARK: FUNCTION
    
    func openCustomUrl(urlString:String){
        guard let url = URL(string: urlString) else {return}
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
    }
    
    func signOut(){
        AuthService.instance.logOutUser { success in
            if success{
                print("Sucessfully to signout")
                
                //dissmiss settings view
                self.presenationMode.wrappedValue.dismiss()
                
                                
            }
            else{
                showError.toggle()
                print("fail to signout")
            }
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    @State static var displayName : String = "Profile Display Name"
    @State static var displayBio : String = "Profile Bio"
    @State static var profileImage : UIImage = UIImage(named: .logoLoading)!
    @State static var feeback : String = "Enter your feed back"

    static var previews: some View {
        SettingsView(user_DisplayName: $displayName, user_Bio: $displayBio,feedback: feeback, profileImage: $profileImage)
            .preferredColorScheme(.light)
    }
}
