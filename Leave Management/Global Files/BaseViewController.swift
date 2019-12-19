//
//  BaseViewController.swift
//  Leave Management
//
//  Created by osx on 09/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import Photos
import RealmSwift
import Alamofire
import NVActivityIndicatorView

class BaseViewController: UIViewController {
    
    
    //MARK: - variables
    let screen = UIScreen.main.bounds.size
    var loader = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize()))
    var user = UserModel()
    
    
    //MARK: - LifeCycle func
    override func viewDidLoad() {
        super.viewDidLoad()
        loader = NVActivityIndicatorView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: screen.width, height: screen.height)), type: .lineSpinFadeLoader, color: Colors.themeColor, padding: .none)
        // Do any additional setup after loading the view.
    }
    
    //MARK:- GetData
    func getUserData(){
        user = user.getUserloggedIn() ?? UserModel()
    }
    
    //MARK: - Loader
    func addLoader(){
        NVActivityIndicatorPresenter.sharedInstance.startAnimating(ActivityData(size: CGSize(width: 50, height: 50), message: "", messageFont: nil, messageSpacing: nil, type: .lineSpinFadeLoader, color: Colors.themeColor, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: Colors.themeTransparentBackground, textColor: Colors.themeColor))
    }
    func removeLoader(){
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    
    
    //MARK: - Validations
    func trimString(_ data: String) -> String {
        return data.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func isValidEmail(_ str:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: str)
    }
    func isValidPassword(_ str:String) -> Bool {
        let regularExpression = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[$@$!%*?&])[A-Za-z\\d$@$!%*?&]{6,}"
        let passwordValidation = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        return passwordValidation.evaluate(with: str)
    }
    func isValidPhoneNumber(_ str:String) -> Bool {
        
        return str.count == 10// && str.count < 15
    }
    
    func isValidText(_ text: String) -> Bool{
        if self.trimString(text).isEmpty {
            return false
        }
        return true
    }
    
    
    
    //MARK: - Show Alert
    func showAlert(title: String, message: String, actionTitle: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: actionTitle, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        self.removeLoader()
    }
    
    func showLogoutAlert() {
        let alert = UIAlertController(title: "Are you sure?", message: "You want to Log out.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.deleteAllFromDatabase()
            UIApplication.shared.applicationIconBadgeNumber = 0
            self.navigationController?.popToRootViewController(animated: true)
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSessionExpiredAlert(){
        // kLogout -------- logout user when token is expired
        let alert = UIAlertController(title: "Session Expired!!", message: "Please login.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in
            self.deleteAllFromDatabase()
            UIApplication.shared.applicationIconBadgeNumber = 0
            self.navigationController?.popToRootViewController(animated: true)
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteAllFromDatabase(){
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    //MARK:- Add Image Picker Controller
    func showActionSheet(pickerDelegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera(pickerDelegate: pickerDelegate)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertAction.Style.default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary(pickerDelegate: pickerDelegate)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func camera(pickerDelegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate))
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = pickerDelegate
            myPickerController.sourceType = UIImagePickerController.SourceType.camera
            myPickerController.cameraDevice = .front
            myPickerController.allowsEditing = false
            self.checkForCameraPermissions(picker: myPickerController)
            // viewController.present(myPickerController, animated: true, completion: nil)
        }
        else
        {
            self.showAlert(title: "Alert!", message: "Sorry! This device does not have camera.", actionTitle: "Ok")
        }
    }
    
    func photoLibrary(pickerDelegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate))
    {
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = pickerDelegate
        myPickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
        myPickerController.allowsEditing = false
        self.checkPhotoLibraryPermission(picker: myPickerController)
        //viewController.present(myPickerController, animated: true, completion: nil)
        
    }
    
    
    func checkPhotoLibraryPermission(picker:UIImagePickerController) {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            //handle authorized status
            self.present(picker, animated: true, completion: nil)
            break
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
            self.present(alertController, animated: true, completion: nil)
            break
        case .restricted:
            let alert = UIAlertController(title: "Restricted",
                                          message: "You've been restricted from using the photos on this device. Without photo library access this feature won't work..",
                                          preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            break
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                    // as above
                    self.present(picker, animated: true, completion: nil)
                    break
                case .denied, .restricted:
                    // as above
                    let alert = UIAlertController(title: "Access for Photos is not allowed", message: "Make changes from settings", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    break
                case .notDetermined:
                    // won't happen but still
                    break
                @unknown default:
                    break
                }
            }
            break
        @unknown default:
            break
        }
    }
    func checkForCameraPermissions(picker: UIImagePickerController) {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch (status)
        {
        case .authorized:
            
            self.present(picker, animated: true, completion: nil)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    self.present(picker, animated: true, completion: nil)
                // as above
                    break
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
            self.present(alertController, animated: true, completion: nil)
            
            
        case .restricted:
            let alert = UIAlertController(title: "Restricted",
                                          message: "You've been restricted from using the photos on this device. Without photos access this feature won't work. Please contact the device owner so they can give you access.",
                                          preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        @unknown default:
            break
        }
        
    }
}
