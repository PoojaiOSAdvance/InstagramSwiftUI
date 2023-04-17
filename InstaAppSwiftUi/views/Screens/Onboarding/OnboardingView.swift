//
//  OnboardingView.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 30/03/23.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct OnboardingView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @State var showOnboardingPart2 : Bool = false
    @State var showError: Bool = false
    
    @State var displayName :String = ""
    @State var Email :String = ""
    @State var providerID :String = ""
    @State var provider :String = ""
    
    var body: some View {
        VStack(spacing: 10,content: {
            Image(String.logoTransparent)
                .resizable()
                .scaledToFit()
                .frame(width: 100,height: 100,alignment: .center)
                .shadow(radius: 12)
            
            Text("Welcome to DogGer")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.MyTheme.purpleColor)
            
            Text("DogGram is the #1 app for posting pictures of your dog and sharing them across the world. We are the dog loving community and we are happy to have you")
                .font(.headline)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(Color.MyTheme.purpleColor)
                .padding()
            
            Button(action: {
                showOnboardingPart2.toggle()
            }, label: {
                SignInWithAppleButtonCustom()
                    .frame(height: 60)
                    .frame(maxWidth: .infinity)
                
            })
            
            Button(action: {
                
                let vc =  UIApplication.shared.windows.first?.rootViewController
                
                GIDSignIn.sharedInstance.signIn(withPresenting: vc!){user,error in
                    
                    var name = ""
                    var email = ""
                    var token = ""
                    var aToken = ""
                    
                    if let idToken = user?.user.idToken{
                        token = idToken.tokenString
                    }
                    
                    if let accessToken = user?.user.accessToken.tokenString{
                        aToken = accessToken
                    }
                    
                    if let uName = user?.user.profile?.name{
                        name = uName
                    }
                    
                    if let uEMail = user?.user.profile?.email{
                        email = uEMail
                    }
                    
                    
                    let credential = GoogleAuthProvider.credential(withIDToken: token, accessToken: aToken)
                    self.connectToFireBase(name: name, email: email, provider: "Google", credential: credential)
                    
                }
                
            }, label: {
                HStack{
                    Image(systemName: "globe")
                    Text("Sign in with Google")
                }
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(Color(.sRGB,red: 222/255, green: 82/255, blue: 70/255,opacity: 1.0))
                .cornerRadius(4)
                .font(.system(size: 23,weight: .medium,design: .default))
                
                
            }).accentColor(.white)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                
                Text("COUNTINE AS GUEST").font(.headline).fontWeight(.medium).padding()
            }).accentColor(.black)
            
        }).padding(.all,20)
            .frame(maxWidth: .infinity,maxHeight: .infinity)
            .background(Color.MyTheme.beigeColor)
            .edgesIgnoringSafeArea(.all)
            .fullScreenCover(isPresented: $showOnboardingPart2,onDismiss: {
                
                self.presentationMode.wrappedValue.dismiss()
            }, content: {
                OnboardingViewPart2(displayName: $displayName, Email: $Email, providerID: $providerID, provider: $provider)
            })
            .alert(isPresented: $showError) {
                return Alert(title: Text("Some thing went wrong"),message: nil,dismissButton: .destructive(Text("Ok")))
            }
            .navigationBarBackButtonHidden()
        
    }
    //MARK: FUNCTION
    
    func connectToFireBase(name:String,email:String,provider:String,credential:AuthCredential){
        
        AuthService.instance.logInUserToFirebase(credential: credential) { (_providerId, _isError,_isNewUser,_returnUserId) in
            
            if let newuser = _isNewUser{
                
                if newuser {
                    
                    if let providerId =  _providerId, !_isError{
                        //SUCCESS
                        //NEW USET ONBOARDING PART
                        
                        self.displayName = name
                        self.Email = email
                        self.providerID = providerId
                        self.provider = provider
                        self.showOnboardingPart2.toggle()
                    }
                    else{
                        showError.toggle()
                        print("EROR GETTING INTO FROM LOG IN USER TO FIREBASE")
                    }
                    
                }
                else{
                    //EXISTING USER
                    
                    if let userID = _returnUserId{
                        AuthService.instance.loggedInUserToApp(userId: userID) { sucess in
                            
                            if sucess{
                                print("SUCCESSFUL LOG IN EXISTING USER TO APP")
                                self.presentationMode.wrappedValue.dismiss()
                            }
                            else{
                                showError.toggle()
                                print("EROR LOG IN EXISTING USER TO APP")
                                
                            }
                        }
                        
                    }
                    else{
                        showError.toggle()
                        print("EROR GETTING Userid INTO FROM LOG IN EXISTING USER TO FIREBASE")
                        
                    }
                }
            }
            else{
                showError.toggle()
                print("EROR GETTING INTO FROM LOG IN USER TO FIREBASE")
                
            }
        }
    }
    
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
