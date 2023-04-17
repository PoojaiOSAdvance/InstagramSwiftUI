//
//  ImageManager.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 04/04/23.
//

import Foundation
import FirebaseStorage

let imageCache = NSCache<AnyObject,UIImage>()

class ImageManager { // Holds images and videos
    
    //MARK: PROPERTIES
    
    static let instance = ImageManager()
    
    private var REF_STOR  = Storage.storage()
    
    
    //MARK: PUBLIC FUNCTIONS
    //FUNCTIONS we call for from other places in the apps
    
    func uplaodProfileIamge(userID:String,image:UIImage){
        
        //get the path where we will save the image
        let path = getProfileImagePath(userId:userID)
        
        DispatchQueue.global(qos: .userInteractive).async {
          
            self.uplaodImage(path: path, image: image) { _ in }
        }
        
    }
   
    func uploadPostImage(postId:String,image:UIImage,handler:@escaping(_ sucess:Bool)->()){
        
        let path = getPostImagePath(postId:postId)
        //save image to path
        DispatchQueue.global(qos: .userInteractive).async {
            
            self.uplaodImage(path: path, image: image) { sucess in
                DispatchQueue.main.async {
                    if sucess{
                        
                        print("SUCESS for UPLoAD POST IMAGE")
                        handler(sucess)
                        
                    }
                    else{
                        print("ERROR for UPLoAD POST IMAGE")
                        handler(false)
                        
                    }
                }
            }
        }
    }
    
    //MARK: Private FUNCTIONS
    //FUNCTIONS we call for from this file only
    
    private func getProfileImagePath(userId:String) -> StorageReference {
      
        let userPath = "users/\(userId)/profile"
        let storagePath = REF_STOR.reference(withPath: userPath)
        return storagePath
    }
    
    private func getPostImagePath(postId:String)->StorageReference{
        
        let postPath = "posts/\(postId)/1"
        let storagePath = REF_STOR.reference(withPath: postPath)
        return storagePath
    }
    private func uplaodImage(path:StorageReference,image:UIImage,handler:@escaping(_ sucess:Bool)->()){
       
        var compression :CGFloat = 1.0  // loop down by 0.05
        var maxFileData :Int = 240 * 240 // Maximum file size that we want to save
        let maxCompression : CGFloat = 0.05 // Maximum compression we ever allow

        // get image data
        guard var originalData = image.jpegData(compressionQuality: compression) else{
            
            print("ERROR GETTING IMAGE")
            handler(false)
            return
        }

        //To check maximum file size
        
        while (originalData.count > maxFileData) && (compression > maxCompression){
            compression -= 0.05
            if let compressionData = image.jpegData(compressionQuality: compression){
                originalData = compressionData
            }
            print(compression)
        }
        
        
        // get image data

        guard let finalData = image.jpegData(compressionQuality: compression) else{
            
            print("ERROR GETTING IMAGE")
            handler(false)
            return
        }
        
        //get photo metadata
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        //save data to path
        path.putData(finalData,metadata: metadata) { _, error in
           
            if let error = error{
              
                print("ERRPR UPLOADING IMAGE. \(error)")
                handler(false)
                return
            }
            else{
                print("success image")
                handler(true)
                return

            }
        }
    }
    
    //MARK: Download
    //getImage
    
    func downloadProfileImage(userId:String,handler:@escaping(_ image:UIImage?)->()){
        
        // get the path where image is saved
        let path = getProfileImagePath(userId: userId)
        
        DispatchQueue.global(qos: .userInteractive).async {
            // download imageFrom path
            self.downloadImage(path: path) { returnedImage in
                print("returnedImage Downloaded in cache")
               
                DispatchQueue.main.async {
                    handler(returnedImage)

                }
            }
        }
    }

    func downloadPostImg(postId:String,handler:@escaping(_ image:UIImage?)->()){
        
        // get the path where image is saved
        
        let path = getPostImagePath(postId: postId)
        
        // download imageFrom path
        DispatchQueue.global(qos: .userInteractive).async {

            self.downloadImage(path: path) { returnedImage in
                print("returnedImage Downloaded in cache")
            
                DispatchQueue.main.async {
                    handler(returnedImage)
                }
            }
        }
    }

    private func downloadImage(path:StorageReference,handler:@escaping(_ image:UIImage?)->()){
        
        //imageCache.removeObject(forKey: path)
        if let cahcedImg = imageCache.object(forKey: path) {
            
            print("Image found in cache")
            handler(cahcedImg)
            return
        }
        else{
            path.getData(maxSize: 27 * 1024 * 1024) { (returnImgData, error) in
                
                if let data = returnImgData, let image = UIImage(data: data){
                    // Success getting img data
                    imageCache.setObject(image, forKey: path)
                    print("Image Downloaded in cache")

                    handler(image)
                    return
                }
                else{
                    print("ERROR GETTING DATA FROM PATH FOR IMAGE")
                    handler(nil)
                    return
                }
            }

        }
    }

}
