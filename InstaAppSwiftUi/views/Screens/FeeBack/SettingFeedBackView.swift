//
//  SettingFeedBackView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 10/04/23.
//

import SwiftUI

struct SettingFeedBackView: View {
    
    @State var feebackSubTitle : String = "Enter your feed back"
    @Binding var selectedTitle : String // title selected
    @State var feebackTitle : String = "Select your feed type"

    @State private var textStyle = UIFont.TextStyle.body
    @State var showtitle : Bool = false

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    var bottomIcon : String
    var color:Color
    
    
    @State  var showAlert : Bool  = false
    @State  var alertTitle : String  = ""

    @AppStorage(CurrentUserDefaults.userId) var userId : String?
    @State var alertType : AlertType = AlertType.OnFailure

    
    var body: some View {
        
        VStack(spacing: 20, content: {
            HStack {
                
                Text("Share your valuable feedback with us!!!")
                    .foregroundColor(.primary)
                    .font(.headline)
                    .fontWeight(.medium)
                Spacer(minLength: 0)
            }
            
            // SELECT TITLE
            Button(action: {
                showtitle.toggle()
            }, label: {
                
                HStack{
                    Text(feebackTitle)
                        .font(.subheadline)
                        .fontWeight(.regular)
                        .foregroundColor(feebackTitle == "Select your feed type" ? .gray : .primary )
                    Spacer(minLength: 0)
                    Image(systemName: bottomIcon).font(.body)
                }
                .padding(.vertical,4)
                
            })
            .accentColor(.primary)
            Divider()
                .padding(.vertical,1)
            
            Spacer()
            
            
            // SELECT SUBTITLE
            
            TextView(text: $feebackSubTitle, textStyle: $textStyle)
            Spacer(minLength: 0)
            
            
            Divider()
                .padding(.vertical,1)
            
            Spacer()
            
            // SELECT SEND FEEDBACK
            
            Button(action: {
                
                if checkConditions(){
                    
                    self.sendfeedBack()
                }
                
            }, label: {
                Text("SEND FEEDBACK")
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
            
        }).padding().frame(maxWidth: .infinity)
            .navigationBarTitle("FeedBack")
        
        
            .sheet(isPresented: $showtitle,onDismiss: {
                self.feebackTitle = selectedTitle != "" ? selectedTitle : "Select your feed type"
            }) {
                FeedBackTitleView(selectedTitle: $selectedTitle)
                
            }
            .alert(isPresented: $showAlert) {
                return getAlert()
            }
        
    }
    
    //MARK: FUNCTION
    
    func ondissmissCurrentPage(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    func getAlert()->Alert{
        switch alertType{
            
        case.OnFailure :
            return Alert(title: Text(alertTitle),message: nil,dismissButton: .destructive(Text("OK")))
            
            
        case .OnSuccess :
            
            return Alert(title: Text(alertTitle),message: nil,dismissButton: .default(Text("OK"),action: {
                self.ondissmissCurrentPage()
            }))
        }
    }

    func checkConditions() -> Bool{
        
        if selectedTitle.isEmpty || selectedTitle == "Select your feed type"{
            
            self.alertTitle = "Please select Feeback title"
            alertType = .OnFailure
            showAlert.toggle()
            return false
        }
        else if feebackSubTitle.isEmpty || feebackSubTitle.contains("Enter your feed back"){
            
            self.alertTitle = "Please Enter feed back"
            alertType = .OnFailure
            showAlert.toggle()
            return false

        }
        
        return true
    }
    
    //MARK: Api call

    func sendfeedBack(){
        
        guard let _userId = userId else{return}
        DataService.instance.uploadFeedback(title: selectedTitle, subTitle: feebackSubTitle, userId: _userId) { success in
            if success {
                
                self.alertTitle = "FeedBack Send Successfully"
                feebackSubTitle = "Enter your feed back"
                self.selectedTitle = "Select your feed type"
                self.feebackTitle = "Select your feed type"
                alertType = .OnSuccess
                showAlert.toggle()

            }
        }
    }
}

struct SettingFeedBackView_Previews: PreviewProvider {
    @State static var feebackTitle : String = "Select your feed type"
    @State static var feebackSubTitle : String = "Enter your feed back"

    static var previews: some View {

        NavigationView {
            SettingFeedBackView(feebackSubTitle: feebackSubTitle,selectedTitle: $feebackTitle, feebackTitle: feebackTitle,bottomIcon: "chevron.down.circle",color: .primary)
        }
    }
}
