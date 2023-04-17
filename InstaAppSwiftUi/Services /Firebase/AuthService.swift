//
//  FirebaseConnect.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 03/04/23.
//
//Used to authenticate firebase
//Used to handle user account in firebase

import Foundation
import FirebaseAuth
import FirebaseFirestore // Database

let DB_BASE = Firestore.firestore()

class AuthService{
    
    //MARK: PROPERTIES
    static let instance  = AuthService()
    private var REF_USERS = DB_BASE.collection("users")
    
    
    //MARK: AUTH USER FUNCTIONS
    
    func logInUserToFirebase(credential :AuthCredential,handler:@escaping(_ _providerId:String?,_ _isError:Bool,_ _isNewUser:Bool?,_ _userId:String?)->()){
        
        Auth.auth().signIn(with: credential){(result,error) in
            
            //check for error
            if error != nil{
                print("Error login in to firebase")
                handler(nil,true,nil,nil)
                return
            }
            //check for providerid
            
            guard let providerId = result?.user.uid else{
                
                print("Error getting provider id")
                handler(nil,true,nil,nil)
                return
            }
            
            //
            //check exitsing
            
            self.checkIfUserExistInDataBase(providerId: providerId) { existingUserId in
                if let userId  = existingUserId{
                    
                    // login to app immediatly
                    handler(providerId,false,false,userId)

                }
                else{
                    
                    //Sucess to connect with firebase

                    // onboarding
                    handler(providerId,false,true,nil)

                }
            }
            
            
        }
    }
    
    func checkIfUserExistInDataBase(providerId:String,handler:@escaping(_ existingUserId:String?)->()){
       //If a userid is returened then the user does't exist in our database
        
        REF_USERS.whereField(DatabaseUserField.providerId, isEqualTo: providerId).getDocuments { (_ querySnapshot, error) in
            
            if let snaopShot = querySnapshot ,snaopShot.count > 0 , let document = snaopShot.documents.first{
                
                let existingUserID = document.documentID
                handler(existingUserID)
                return
            }
            else{
                handler(nil)
                return
            }
        }
    }

    func loggedInUserToApp(userId:String,handler: @escaping(_ sucess : Bool)->()){
        
        //get the users info
        getUserInfo(forUserId: userId) { name, bio in
            if let name = name , let bio = bio{
               
                print("Success")
                handler(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                    
                    //set the users info our app in userdefaults
                    UserDefaults.standard.set(userId, forKey: CurrentUserDefaults.userId)
                    UserDefaults.standard.set(bio, forKey: CurrentUserDefaults.bio)
                    UserDefaults.standard.set(name, forKey: CurrentUserDefaults.displayName)

                }

            }
            else{
                print("Error")
                handler(false)

            }
        }
          
    }
    
    func createNewUserInDataBase(name:String,email:String,providerId:String,provider:String,profileImage:UIImage,handler:@escaping(_ userId:String?)->()){
        
        //Setup a user document with the user collection
        let document = REF_USERS.document()
        let userId = document.documentID
        
        //upload profile image to storage
        ImageManager.instance.uplaodProfileIamge(userID: userId, image: profileImage)
        
        // upload profile data to firestore
        let userData : [String:Any] = [
            
            DatabaseUserField.displayName : name,
            DatabaseUserField.email : email,
            DatabaseUserField.providerId : providerId,
            DatabaseUserField.provider : provider,
            DatabaseUserField.userId : userId,
            DatabaseUserField.bio : "",
            DatabaseUserField.dateCreated : FieldValue.serverTimestamp()
        ]
        
        document.setData(userData) { error in
            if let error = error
            {
                //ERROR
                print("ERROR UPLOADING USERDOCUMENT\(error)")
                handler(nil)
            }
            else{
                //SUCCESS
                handler(userId)
            }
        }
        
    }
    
    
    func logOutUser(handler: @escaping(_ success: Bool)->()){
        
        do{
            
            try Auth.auth().signOut()
            
        }catch let error{
            
            debugPrint(error.localizedDescription)
            handler(false)

        }
        handler(true)
        // updateUserDefault
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            
            let userDefaultDict =  UserDefaults.standard.dictionaryRepresentation()
            userDefaultDict.keys.forEach { key in
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
    
    // MARK: GET USER FUNCTIONS
    
    func getUserInfo(forUserId userId :String ,handler:@escaping(_ name : String?,_ bio:String?)->()){
        
        REF_USERS.document(userId).getDocument { documentSnapshot, error in
            
            if let document = documentSnapshot, let name  = document.get(DatabaseUserField.displayName) as? String , let bio = document.get(DatabaseUserField.bio) as? String{
                
                print("Sucess getting user info")
                handler(name,bio)

                return
            }
            else{
                print("ERRRO GETTING USER INFO")
                handler(nil,nil)
            }
        }
    }
    
    //MARK: UPDATE USER DISPLAY NAME
    
    func updateUserDisplayName(userId :String,displayName:String,handler:@escaping(_ success:Bool)->()){
        
        let data :[String:Any] = [
            CurrentUserDefaults.displayName : displayName
        ]
        REF_USERS.document(userId).updateData(data) { error in
            
            if let _error = error{
                
                print("ERROR WHILE UPDATE USER NAME IN DATABASE\(_error)")
                handler(false)
                return

            }
            else{
                
                handler(true)
                return
            }
        }
        
    }
    
    
    //MARK: UPDATE USER DISPLAY Bio
    
    func updateUserBio(userId :String,bio:String,handler:@escaping(_ success:Bool)->()){
        
        let data :[String:Any] = [
            CurrentUserDefaults.bio : bio
        ]
        REF_USERS.document(userId).updateData(data) { error in
            
            if let _error = error{
                
                print("ERROR WHILE UPDATE USER Bio IN DATABASE\(_error)")
                handler(false)
                return

            }
            else{
                
                handler(true)
                return
            }
        }
        
    }
    

}
