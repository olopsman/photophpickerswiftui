//
//  PhotoPicker.swift
//  PhotoPHPickerSwiftUI
//
//  Created by Paulo Orquillo on 5/12/21.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    
    //need to pass the binding
    @Binding var images: [UIImage]
        
    func makeUIViewController(context: Context) -> PHPickerViewController {
        //set the configuration for the picker
        var config = PHPickerConfiguration()
        config.filter = .images
        config.preferredAssetRepresentationMode = .current
        //limit of 0 allows for multiple selection
        config.selectionLimit = 0
        let picker = PHPickerViewController(configuration: config)
        //set the delegate which is the coordinator
        picker.delegate = context.coordinator
        return picker
    }
    
    // not used by needed for conformance
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {   }
    
    func makeCoordinator() -> Coordinator {
        //pass instance of self
        return Coordinator(photoPicker: self)
    }

    // need to conform to nsobject, picker has navigation
    class Coordinator: NSObject, UINavigationControllerDelegate, PHPickerViewControllerDelegate {
        
        //pass instance of the photopicker
        var photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            // loop the results/selections
            results.forEach { result in
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    // bug on loadObject with reading images - fix is to use loadDataRepresentation instead
                    result.itemProvider.loadDataRepresentation(forTypeIdentifier: "public.image") { (data, err) in
                        guard let dataValue = data else {
                            return
                        }
                        let imageValue = UIImage(data: dataValue)
                        //append the values
                        self.photoPicker.images.append(imageValue!)
                    }
                    /***
                    // failes on retrieving image- version=1&uuid=CC95F08C-88C3-4012-9D6D-64A413D254B3&mode=current.jpeg” couldn’t be opened because there is no such file.
                    //https://developer.apple.com/forums/thread/658135
                    //https://developer.apple.com/forums/thread/654021
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, err) in
                        guard let imageValue = image else {
                            return
                        }

                        //append the values
                        self.photoPicker.images.append(imageValue as! UIImage)

                    }
                     */
                } else {
                    //cannot load the image, do some alerts
                }
            }
            
            picker.dismiss(animated: true)
        }
        
    }
    
}
