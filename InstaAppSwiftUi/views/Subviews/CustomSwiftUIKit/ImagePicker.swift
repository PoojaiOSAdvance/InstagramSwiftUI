//
//  ImagePicker.swift
//  InstaAppSwiftUi
//
//  Created by Pooja Raghuwanshi on 28/03/23.
//

import Foundation
import SwiftUI

struct ImagePicker : UIViewControllerRepresentable{
    @Binding var selectedImage : UIImage
    @Binding var sourceType : UIImagePickerController.SourceType
  
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext <ImagePicker>) -> some UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = true
        return picker
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        print("update image")
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(parent: self)
    }
    class ImagePickerCoordinator : NSObject,UINavigationControllerDelegate,UIImagePickerControllerDelegate{
       
        let parent : ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
         
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if  let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.presentationMode.wrappedValue.dismiss()
              // Select Image for App
             // Dismiss the screen
            }
        }
        
    }
}
