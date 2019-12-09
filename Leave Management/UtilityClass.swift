//
//  UtilityClass.swift
//  Leave Management
//
//  Created by osx on 04/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos


class Utility{
    
    // MARK: AlertController
     func showAlert(title: String, message: String, viewController: UIViewController){
     
     let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
     alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
    // alert.dismiss(animated: true, completion: nil)
     
     }))
     viewController.present(alert, animated: true, completion: nil)
     
     }
    
    
    //MARK:- Add image
    func camera(viewController: UIViewController, pickerDelegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate))
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = pickerDelegate
            myPickerController.sourceType = UIImagePickerController.SourceType.camera
            myPickerController.cameraDevice = .front
            myPickerController.allowsEditing = false
            self.checkForCameraPermissions(picker: myPickerController, viewController: viewController)
            // viewController.present(myPickerController, animated: true, completion: nil)
        }
        else
        {
            self.showAlert(title: "Alert!", message: "Sorry! This device does not have camera.", viewController: viewController.navigationController ?? viewController)
        }
    }
    
    func photoLibrary(viewController: UIViewController, pickerDelegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate))
    {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = pickerDelegate
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerController.allowsEditing = false
        self.checkPhotoLibraryPermission(picker: myPickerController, viewController: viewController)
        //viewController.present(myPickerController, animated: true, completion: nil)
        
    }
    
    func showActionSheet(viewController: UIViewController, pickerDelegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera(viewController: viewController, pickerDelegate: pickerDelegate)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary(viewController: viewController, pickerDelegate: pickerDelegate)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        viewController.present(actionSheet, animated: true, completion: nil)
        
    }
    func checkPhotoLibraryPermission(picker:UIImagePickerController, viewController: UIViewController) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //handle authorized status
            viewController.present(picker, animated: true, completion: nil)
        case .denied :
            //handle denied status
            let alertController = UIAlertController(title: NSLocalizedString("Allow access to use photo library", comment: ""), message: NSLocalizedString("Open settings to make changes.", comment: ""), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                //openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            }
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            viewController.present(alertController, animated: true, completion: nil)
            
        case .restricted:
            let alert = UIAlertController(title: "Restricted",
                                          message: "You've been restricted from using the photos on this device. Without photo library access this feature won't work..",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            viewController.present(alert, animated: true, completion: nil)
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    // as above
                    viewController.present(picker, animated: true, completion: nil)
                case .denied, .restricted:
                    // as above
                    let alert = UIAlertController(title: "Access for Photos is not allowed", message: "Make changes from settings", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    viewController.present(alert, animated: true, completion: nil)
                case .notDetermined:
                    // won't happen but still
                    break
                    @unknown default:
                    break
                }
            }
            @unknown default:
            break
        }
    }
    func checkForCameraPermissions(picker: UIImagePickerController, viewController: UIViewController) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch (status)
        {
        case .authorized:
            
            viewController.present(picker, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    viewController.present(picker, animated: true, completion: nil)
                // as above
                case .denied, .restricted: break
                // as above
                case .notDetermined: break
                    // won't happen but still
                @unknown default:
                    break
                }
            }
        case .denied:
            let alertController = UIAlertController(title: NSLocalizedString("Allow access to use your photos", comment: ""), message: NSLocalizedString("Open settings to make changes.", comment: ""), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
            let settingsAction = UIAlertAction(title: NSLocalizedString("Settings", comment: ""), style: .default) { (UIAlertAction) in
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                //openURL(NSURL(string: UIApplication.openSettingsURLString)! as URL)
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(settingsAction)
            viewController.present(alertController, animated: true, completion: nil)
            
            
        case .restricted:
            let alert = UIAlertController(title: "Restricted",
                                          message: "You've been restricted from using the photos on this device. Without photos access this feature won't work. Please contact the device owner so they can give you access.",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            viewController.present(alert, animated: true, completion: nil)
            
            @unknown default:
            break
        }
        
    }
}
