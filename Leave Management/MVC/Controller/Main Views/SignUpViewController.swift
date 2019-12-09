//
//  SignUpViewController.swift
//  Leave Management
//
//  Created by osx on 04/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField


class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    //MARK:- Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var tfFullName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var tfPhoneNumber: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var tfDesignation: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var tfConfirmPassword: SkyFloatingLabelTextFieldWithIcon!
    
    //MARK:- Variables
    
    
    //MARK:- Lifecycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.callViewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addNotifications()
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.removeNotifications()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        
    }
    
    //MARK:- main funcs
    private func callViewDidLoad()
    {
        
        self.tfFullName.delegate = self
        self.tfEmail.delegate = self
        self.tfPhoneNumber.delegate = self
        self.tfDesignation.delegate = self
        self.tfPassword.delegate = self
        self.tfConfirmPassword.delegate = self
        
        self.setupToHideKeyboardOnTapOnView()
        self.addAccessoryViewForPhoneNumberField()
    }
    private func callViewWillLoad()
    {
        
    }
    
    private func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
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
            tfPassword.becomeFirstResponder()
        }else if textField == tfPassword
        {
            tfConfirmPassword.becomeFirstResponder()
        }else if textField == tfConfirmPassword
        {
            tfConfirmPassword.resignFirstResponder()
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
    
    //MARK:- Button Actions
    
    @IBAction func btnPasswordAction(_ sender: UIButton) {
        if sender.tag == 0//show password
        {
            sender.tag = 1
            self.tfPassword.isSecureTextEntry = false
            sender.setImage(eyeShown, for: .normal)
        }
        else{//hide password
            sender.tag = 0
            self.tfPassword.isSecureTextEntry = true
            sender.setImage(eyeHidden, for: .normal)
        }
    }
    @IBAction func btnConfirmPasswordAction(_ sender: UIButton) {
        if sender.tag == 0//show password
        {
            sender.tag = 1
            self.tfConfirmPassword.isSecureTextEntry = false
            sender.setImage(eyeShown, for: .normal)
        }
        else{//hide password
            sender.tag = 0
            self.tfConfirmPassword.isSecureTextEntry = true
            sender.setImage(eyeHidden, for: .normal)
        }
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSignUpAction(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: kHomeViewController) as? HomeViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }



}
