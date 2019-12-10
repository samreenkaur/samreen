//
//  EditProfileViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

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
    var user = UserModel()
    
    //MARK:- Lifecycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.callViewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addNotifications()
        self.callViewWillLoad()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeNotifications()
    }
    
    
    //MARK:- main funcs
    private func callViewDidLoad()
    {
        
        self.tfFullName.delegate = self
        self.tfEmail.delegate = self
        self.tfPhoneNumber.delegate = self
        self.tfDesignation.delegate = self
        self.imagePicker.delegate = self
        self.setupToHideKeyboardOnTapOnView()
        self.addAccessoryViewForPhoneNumberField()
    }
    private func callViewWillLoad()
    {
        user = user.getUserloggedIn() ?? UserModel()
        if user.id > 0
        {
            self.tfFullName.text = user.fullName
            self.tfEmail.text = user.email
            self.tfPhoneNumber.text = user.phoneNumber
            self.tfDesignation.text = user.designation
            
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
            tfEmail.becomeFirstResponder()
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
    
    //MARK:- Notifications
    private func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
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
        self.tfDesignation.resignFirstResponder()
    }
    
    
    //MARK:- UIIMagePicker Controller Delegate func
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            self.imgUser.image = image
        }
        else if let image = info[.originalImage] as? UIImage {
            self.imgUser.image = image
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
            self.apiHit()
        }
        
    }
    
    //MARK:- API Hit
    private func apiHit(){
        let name = self.trimString(self.tfFullName.text ?? "")
        let email = self.trimString(self.tfEmail.text ?? "")
        let phoneNumber = self.trimString(self.tfPhoneNumber.text ?? "")
        let designation = self.trimString(self.tfDesignation.text ?? "")
        user.realm?.beginWrite()
        user.fullName = name
        user.email = email
        user.phoneNumber = phoneNumber
        user.designation = designation
        //        RealmDatabase.shared.add(object: user)
        do {
            try user.realm?.commitWrite()
        } catch {
            print(error.localizedDescription)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}
