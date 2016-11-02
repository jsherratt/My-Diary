//
//  MediaPickerManager.swift
//  My Diary
//
//  Created by Joey on 02/11/2016.
//  Copyright © 2016 Joe Sherratt. All rights reserved.
//

import UIKit
import MobileCoreServices

//---------------------
//MARK: Protocol
//---------------------
protocol MediaPickerManagerDelegate: class {
    
    func mediaPickerManager(manager: MediaPickerManager, didFinishPickingImage image: UIImage)
}

class MediaPickerManager: NSObject {
    
    //---------------------
    //MARK: Variables
    //---------------------
    weak var delegate: MediaPickerManagerDelegate?
    fileprivate let imagePickerController = UIImagePickerController()
    fileprivate let presentingViewController: UIViewController
    
    //---------------------
    //MARK: Init
    //---------------------
    init(withPresentingViewController presentingViewController: UIViewController) {
        
        self.presentingViewController = presentingViewController
        super.init()
        
        imagePickerController.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            imagePickerController.sourceType = .camera
            imagePickerController.cameraDevice = .front
            
        } else {
            imagePickerController.sourceType = .photoLibrary
        }
        imagePickerController.mediaTypes = [kUTTypeImage as String]
    }
    
    //---------------------
    //MARK: Functions
    //---------------------
    func presentImagePickerController(animated: Bool) {
        
        presentingViewController.present(imagePickerController, animated: animated, completion: nil)
    }
    
    func dismissImagePickerController(animated: Bool) {
        
        imagePickerController.dismiss(animated: animated, completion: nil)
    }
}

//---------------------
//MARK: Extension
//---------------------
extension MediaPickerManager: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    //----------------------------
    //MARK: Image Picker Delegate
    //----------------------------
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        delegate?.mediaPickerManager(manager: self, didFinishPickingImage: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        imagePickerController.dismiss(animated: true, completion: nil)
    }
}














