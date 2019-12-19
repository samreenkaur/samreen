//
//  EditProfileViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import RealmSwift


class EditProfileViewController: BaseViewController , UITextFieldDelegate , UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    //MARK:- Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var btnUploadImg: UIButton!
    @IBOutlet weak var tfFullName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var tfPhoneNumber: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var tfDesignation: SkyFloatingLabelTextFieldWithIcon!
    
    
    //MARK:- Variables
    var imagePicker = UIImagePickerController()
    var imageUpdated = false
    
    //MARK:- Lifecycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.callViewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callViewWillLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    //MARK:- main funcs
    private func callViewDidLoad()
    {
        self.getUserData()
        self.tfFullName.delegate = self
        self.tfEmail.delegate = self
        self.tfPhoneNumber.delegate = self
        self.tfDesignation.delegate = self
        self.imagePicker.delegate = self
        self.tfEmail.isUserInteractionEnabled = false
        self.setupToHideKeyboardOnTapOnView()
        self.addAccessoryViewForPhoneNumberField()
    }
    private func callViewWillLoad()
    {
        user = user.getUserloggedIn() ?? UserModel()
        if !user.id.isEmpty
        {
            self.tfFullName.text = user.fullName
            self.tfEmail.text = user.email
            self.tfPhoneNumber.text = user.phoneNumber
            self.tfDesignation.text = user.designation
            if user.profilePic.isEmpty{
                self.imgUser.image = Images.userPlaceholder
            }else{
                self.imgUser.sd_setImage(with: URL(string: APIUrl.base + user.profilePic), placeholderImage: Images.userPlaceholder)
            }
        }
    }
    
    private func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationItem.title = "Edit Profile"
        //        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(self.rightBarButtonAction(_:)))
    }
    
    @objc func rightBarButtonAction(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    //MARK:- TextField Delegate func
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfFullName
        {
            tfPhoneNumber.becomeFirstResponder()
        }else if textField == tfEmail
        {
            tfPhoneNumber.becomeFirstResponder()
        }else if textField == tfPhoneNumber
        {
            tfDesignation.becomeFirstResponder()
        }else if textField == tfDesignation
        {
            tfDesignation.resignFirstResponder()
        }
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == tfPhoneNumber && (tfPhoneNumber.text?.count ?? 0 >= 10) && string != ""
        {
            return false
        }else if textField.text?.count ?? 0 >= 50 && string != ""{
            return false
        }
        return true
    }
    
    
    func addAccessoryViewForPhoneNumberField() {
        let btnNext = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44))
        btnNext.backgroundColor = UIColor.white
        btnNext.setTitle(NSLocalizedString("Next", comment: ""), for: .normal)
        btnNext.setTitleColor(UIColor.black, for: .normal)
        btnNext.addTarget(self, action: #selector(self.actionOnDonePhonenumber), for: .touchUpInside)
        tfPhoneNumber.inputAccessoryView = btnNext
    }
    @objc func actionOnDonePhonenumber()
    {
        self.tfDesignation.becomeFirstResponder()
    }
    
    
    //MARK:- UIIMagePicker Controller Delegate func
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.imgUser.image = image
            self.imageUpdated = true
        }
        else if let image = info[.originalImage] as? UIImage {
            self.imgUser.image = image
            self.imageUpdated = true
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK:- Button Actions
    @IBAction func btnUploadImageAction(_ sender: UIButton) {
        
        self.showActionSheet(pickerDelegate: self)
    }
    @IBAction func btnSaveAction(_ sender: UIButton) {
        let name = self.trimString(self.tfFullName.text ?? "")
        let email = self.trimString(self.tfEmail.text ?? "")
        let phoneNumber = self.trimString(self.tfPhoneNumber.text ?? "")
        let designation = self.trimString(self.tfDesignation.text ?? "")
        
        if !self.isValidText(name){
            self.showAlert(title: "Warning", message: "Please enter your fullname.", actionTitle: "Ok")
        }else if !self.isValidText(email){
            self.showAlert(title: "Warning", message: "Please enter your email.", actionTitle: "Ok")
        }else if !self.isValidEmail(email){
            self.showAlert(title: "Warning", message: "Please enter valid email.", actionTitle: "Ok")
        }else if !self.isValidText(phoneNumber){
            self.showAlert(title: "Warning", message: "Please enter your phone number.", actionTitle: "Ok")
        }else if !self.isValidPhoneNumber(phoneNumber){
            self.showAlert(title: "Warning", message: "Please enter valid phone number.", actionTitle: "Ok")
        }else if !self.isValidText(designation){
            self.showAlert(title: "Warning", message: "Please enter your designation.", actionTitle: "Ok")
        }else{
            if self.imageUpdated
            {
                self.uploadImageApiHit()
            }else{
                self.apiHit("")
            }
        }
        
    }
    
    //MARK:- API Hit
    private func apiHit(_ uploadImageUrl: String){
        let name = self.trimString(self.tfFullName.text ?? "")
        let email = self.trimString(self.tfEmail.text ?? "")
        let phoneNumber = self.trimString(self.tfPhoneNumber.text ?? "")
        let designation = self.trimString(self.tfDesignation.text ?? "")
        
        let url = APIUrl.base + APIUrl.editProfile
        var parameters : Parameters = ["FullName": name,"Email": email,"Phone": phoneNumber,"Designation": designation]
        if !uploadImageUrl.isEmpty
        {
            parameters["ProfilePictureUrl"] = uploadImageUrl
        }
        let headers: HTTPHeaders = ["Authorization": user.tokenType + " " + user.accessToken]
        
        self.addLoader()
        print("\n\n\nAPI::: \(url) \nParamteres::: \(parameters) \nHeaders::: \(headers)")
        Alamofire.request(url, method: .post, parameters: parameters,encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result
            {
            case .success(_):
                
                if let data = response.result.value as? [String:AnyObject]
                {
                    if let success = data["Success"] as? Int, success == 1,let responsedata = data["Data"] as? [String:AnyObject]
                    {
                        let model = UserModel.init(dict: responsedata)
                        do {
                            let realm = try Realm()
                            try realm.write {
                                realm.add(model, update: .all)
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                        self.removeLoader()
                        self.navigationController?.popViewController(animated: true)
                    }
                    else if let message = data["Message"] as? String
                    {
                        self.showAlert(title: "Error", message: message, actionTitle: "Ok")
                    }
                }
                else
                {
                    self.showAlert(title: "Error", message: "", actionTitle: "Ok")
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        //        user.realm?.beginWrite()
        //        user.fullName = name
        //        user.email = email
        //        user.phoneNumber = phoneNumber
        //        user.designation = designation
        //        do {
        //            try user.realm?.commitWrite()
        //        } catch {
        //            print(error.localizedDescription)
        //        }
        //        self.navigationController?.popViewController(animated: true)
    }
    private func uploadImageApiHit(){
        let name = self.trimString(self.tfFullName.text ?? "")
        let email = self.trimString(self.tfEmail.text ?? "")
        let phoneNumber = self.trimString(self.tfPhoneNumber.text ?? "")
        let designation = self.trimString(self.tfDesignation.text ?? "")
        
        let url = APIUrl.base + APIUrl.editProfile
        let parameters : Parameters = ["FullName": name,"Email": email,"Phone": phoneNumber,"Designation": designation]
        
        let headers: HTTPHeaders = ["Authorization": user.tokenType + " " + user.accessToken]
        
        self.addLoader()
        print("\n\n\nAPI::: \(url) \nParamteres::: \(parameters) \nHeaders::: \(headers)")
        Alamofire.request(url, method: .post, parameters: parameters,encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result
            {
            case .success(_):
                
                if let data = response.result.value as? [String:AnyObject]
                {
                    if let success = data["Success"] as? Int, success == 1,let responsedata = data["Data"] as? [String:AnyObject]
                    {
                        self.apiHit("url")
                    }
                    else if let message = data["Message"] as? String
                    {
                        self.showAlert(title: "Error", message: message, actionTitle: "Ok")
                    }
                }
                else
                {
                    self.showAlert(title: "Error", message: "", actionTitle: "Ok")
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
        
        //        user.realm?.beginWrite()
        //        user.fullName = name
        //        user.email = email
        //        user.phoneNumber = phoneNumber
        //        user.designation = designation
        //        do {
        //            try user.realm?.commitWrite()
        //        } catch {
        //            print(error.localizedDescription)
        //        }
        //        self.navigationController?.popViewController(animated: true)
    }
    
}
