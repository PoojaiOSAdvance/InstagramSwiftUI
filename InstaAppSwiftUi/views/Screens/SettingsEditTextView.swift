//
//  SettingsEditTextView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 30/03/23.
//

import SwiftUI


struct SettingsEditTextView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @State var submissionText : String = ""
    @State var title : String
    @State var description : String
    @State var placeholder : String
    @State var settingEditTextOption : SettingEditTextOption
    @Binding var profileText : String
    @AppStorage(CurrentUserDefaults.userId) var _userId : String?
    @State var showSuccessAlert : Bool = false
    
    let haptics = UINotificationFeedbackGenerator()


    var body: some View {
        VStack{
            HStack{
                Text(description)
                Spacer(minLength: 0)
            }
            TextField(placeholder,text: $submissionText)
                .padding()
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(colorScheme == .light ? Color.MyTheme.beigeColor : Color.MyTheme.purpleColor )
                .cornerRadius(12)
                .font(.headline)
                .autocapitalization(.sentences)

            Button(action: {
                if textInAppropriate(){
                    saveText()
                }
            }, label: {
                Text("SAVE")
                    .font(.title3)
                    .fontWeight(.bold)
                    .padding()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                    .background(colorScheme == .light ? Color.MyTheme.purpleColor : Color.MyTheme.yellowColor)
                    .cornerRadius(12)
            })
            .accentColor(colorScheme == .light ? Color.MyTheme.yellowColor : Color.MyTheme.purpleColor)
           
            Spacer()
        }.padding().frame(maxWidth: .infinity)
        .navigationBarTitle(title)
        .alert(isPresented: $showSuccessAlert) {
            
            return Alert(title: Text("SAVED !!! 🤩"),message: nil,dismissButton: .default(Text("OK"),action: {
                self.dissmissView()
            }))
        }
    }
    
    //MARK: FUNCTION
    
    func dissmissView(){
        
        self.haptics.notificationOccurred(.success)
        presentationMode.wrappedValue.dismiss()

    }
    
    func textInAppropriate()->Bool{
        
        // check if the text has curses
        // check if the text is long enough
        // check if the text is blank
        // check for innappropriate
      
        // checking for bad word
        let badWordArray :[String] = ["shit","ass"]
        
        let words = submissionText.components(separatedBy: " ")
        
        for word in words {
            
            if badWordArray.contains(word){
                
                return false
            }
        }
        // checking for minimum character count

        if submissionText.count < 3{
            return false
        }
        return true

    }
    
    func saveText(){
        
        switch settingEditTextOption{
            
        case .displayName:
            
            editUserName()
            
            
        case .bio :
            
            editBio()
            
        case .feedback:
            print("cxs")
        }
    }
    func editUserName(){
        
        // update ui on profile name
        profileText = submissionText

        // update userDefault
        UserDefaults.standard.set(submissionText, forKey: CurrentUserDefaults.displayName)

        // update all post of user
        
        guard let currentUserID = _userId else{return}
        DataService.instance.updateDisplayNameOnPosts(userId: currentUserID, displayName: submissionText)
      
        // update user profile in database
        
        AuthService.instance.updateUserDisplayName(userId: currentUserID, displayName: submissionText) { success in
            
            if success {
                
                showSuccessAlert.toggle()
            }
            else{
                
                print("NOT UPDATED VALUES userName")
            }
        }


    }
    
    func editBio(){
        
        // update ui on profile Bio
        
        profileText = submissionText
        
        // update userDefault
        UserDefaults.standard.set(submissionText, forKey: CurrentUserDefaults.bio)
        
        
        // update user profile in database
        
    
        guard let currentUserID = _userId else{return}

        AuthService.instance.updateUserBio(userId: currentUserID, bio: submissionText) { success in
            
            if success {
                
                showSuccessAlert.toggle()
            }
            else{
                
                print("NOT UPDATED VALUES Bio")
            }
        }
        
    }
    
}

struct SettingsEditTextView_Previews: PreviewProvider {
    @State static var text : String = ""
    
    static var previews: some View {
        NavigationView {
            SettingsEditTextView(submissionText: "",title: "Test Title", description: "This is the Description so we can say that they are doing in this screen.", placeholder: "PlaceHolder", settingEditTextOption: .displayName, profileText: $text)
                .preferredColorScheme(.dark)

        }
    }
}
 
