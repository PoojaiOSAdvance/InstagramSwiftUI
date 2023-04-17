//
//  OnboardingViewPart2.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 30/03/23.
//

import SwiftUI

struct OnboardingViewPart2: View {
    @Binding var displayName :String
    @Binding var Email :String
    @Binding var providerID :String
    @Binding var provider :String
    
    @State var selectImage : UIImage = UIImage(named:"logo")! // Image show in this screen
    @State var showImagePicker : Bool = false
    @State var sourceType : UIImagePickerController.SourceType = UIImagePickerController.SourceType.photoLibrary
    @State var showError = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center,spacing: 20, content: {
        Text("What's Your Name ?")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color.MyTheme.yellowColor)
            
            TextField("Add your name here...", text: $displayName)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color.MyTheme.beigeColor)
                .cornerRadius(12)
                .font(.headline)
                .autocapitalization(.sentences)
                .padding(.horizontal)
                .foregroundColor(.black)

            Button(action: {
                showImagePicker.toggle()

            }, label: {
                Text("Finish: Add profile pickure")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(Color.MyTheme.yellowColor)
                    .cornerRadius(12)
                    .padding(.horizontal)
                            
            }).accentColor(Color.MyTheme.purpleColor)
                .opacity(displayName != "" ? 1.0 : 0.0)
                .animation(.easeOut(duration: 1.0))

        })
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(Color.MyTheme.purpleColor)
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $showImagePicker,onDismiss: createProfile,content:  {
            ImagePicker(selectedImage: $selectImage, sourceType: $sourceType)
        })
        .alert(isPresented: $showError) {()-> Alert in
            return Alert(title: Text("Error creating profile🥹🥲"))
        }
    }
    
    //MARK: FUNCTION
    
    func createProfile(){
        print("create profile")
        AuthService.instance.createNewUserInDataBase(name: displayName, email: Email, providerId: providerID, provider: providerID, profileImage: selectImage) { userId in
            
            if let _userId = userId{
              
                print("Sucessfully created user in database")
                AuthService.instance.loggedInUserToApp(userId:_userId){ success in
                   
                    if success {
                        
                        print("user login")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }
                    else{
                        print("error login")
                        self.showError.toggle()
                    }
                    
                }

            }
            else{
                print("Fail to create user in database")
                showError.toggle()
            }
        }
        
    }
}

struct OnboardingViewPart2_Previews: PreviewProvider {
    
    @State static var testString :String = ""
    static var previews: some View {
        OnboardingViewPart2(displayName: $testString, Email: $testString, providerID: $testString, provider: $testString)
    }
}
