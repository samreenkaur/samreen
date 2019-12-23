//
//  SignUpViewController.swift
//  Leave Management
//
//  Created by osx on 04/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import RealmSwift
import Alamofire


class SignUpViewController: BaseViewController, UITextFieldDelegate {
    
    
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
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    
    //MARK:- Button Actions
    
    @IBAction func btnPasswordAction(_ sender: UIButton) {
        //        if sender.tag == 0//show password
        //        {
        //            sender.tag = 1
        //            self.tfPassword.isSecureTextEntry = false
        //            sender.setImage(eyeShown, for: .normal)
        //        }
        //        else{//hide password
        //            sender.tag = 0
        //            self.tfPassword.isSecureTextEntry = true
        //            sender.setImage(eyeHidden, for: .normal)
        //        }
    }
    @IBAction func btnConfirmPasswordAction(_ sender: UIButton) {
        //        if sender.tag == 0//show password
        //        {
        //            sender.tag = 1
        //            self.tfConfirmPassword.isSecureTextEntry = false
        //            sender.setImage(eyeShown, for: .normal)
        //        }
        //        else{//hide password
        //            sender.tag = 0
        //            self.tfConfirmPassword.isSecureTextEntry = true
        //            sender.setImage(eyeHidden, for: .normal)
        //        }
    }
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func btnSignUpAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let name = self.trimString(self.tfFullName.text ?? "")
        let email = self.trimString(self.tfEmail.text ?? "")
        let phoneNumber = self.trimString(self.tfPhoneNumber.text ?? "")
        let designation = self.trimString(self.tfDesignation.text ?? "")
        let password = self.trimString(self.tfPassword.text ?? "")
        let confirmPassword = self.trimString(self.tfConfirmPassword.text ?? "")
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
        }else if !self.isValidText(password){
            self.showAlert(title: "Warning", message: "Please enter your password.", actionTitle: "Ok")
        }else if !self.isValidPassword(password){
            self.showAlert(title: "Warning", message: "Password must contain 6 characters and atleast one uppercase, one lowercase, one digit, one special character.", actionTitle: "Ok")
        }else if !self.isValidText(confirmPassword){
            self.showAlert(title: "Warning", message: "Please confirm your password.", actionTitle: "Ok")
        }else if password != confirmPassword{
            self.showAlert(title: "Warning", message: "Password doesn't match.", actionTitle: "Ok")
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
        let password = self.trimString(self.tfPassword.text ?? "")
        let confirmPassword = self.trimString(self.tfConfirmPassword.text ?? "")
        
        let url = APIUrl.base + APIUrl.signUp
        let parameters : Parameters = ["FullName": name,"Email": email,"Phone": phoneNumber,"Designation": designation,"Password": password, "ConfirmPassword": confirmPassword]
        
        self.addLoader()
        print("\n\n\nAPI::: \(url) \nParamteres::: \(parameters)")
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            switch response.result
            {
            case .success(_):
                
                if let data = response.result.value as? [String:AnyObject]
                {
                    if let success = data["Success"] as? Int, success == 1
                    {
                        self.apiTokenHit()
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
                
                //                            let model = UserModel.init(dict: response.result.value as! [String : AnyObject])
                //                            do {
                //                                let realm = try Realm()
                //                                try realm.write {
                //                                    realm.add(model, update: .all)
                //                                }
                //                            } catch let error as NSError {
                //                                print(error)
            //                            }
            case .failure(let error):
                print(error.localizedDescription)
                self.showAlert(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
            }
        }
        
        
    }
    
    private func apiTokenHit(){
        let email = self.trimString(self.tfEmail.text ?? "")
        let password = self.trimString(self.tfPassword.text ?? "")
        
        let url = APIUrl.base + APIUrl.token
        let parameters : Parameters = ["username": email,"Password": password,"grant_type": "password","client_id": "LeaveManagement", "client_secret": "leaveManagement!46#"]
        
        self.addLoader()
        print("\n\n\nAPI::: \(url) \nParamteres::: \(parameters)")
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            switch response.result
            {
            case .success(_):
                
                if let data = response.result.value as? [String:AnyObject]
                {
                    if let message = data["error"] as? String, let desc = data["error_description"] as? String
                    {
                        print(message)
                        self.showAlert(title: "Error", message: desc, actionTitle: "Ok")
                    }
                    else
                    {
                        let model = UserModel.init(dict: data)
                        do {
                            let realm = try Realm()
                            try realm.write {
                                realm.add(model, update: .all)
                            }
                        } catch let error as NSError {
                            print(error)
                        }
                        self.removeLoader()
                        
                        if let vc = self.storyboard?.instantiateViewController(withIdentifier: kHomeViewController) as? HomeViewController
                        {
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                }
                else
                {
                    self.showAlert(title: "Error", message: "", actionTitle: "Ok")
                }
                
                break
            case .failure(let error):
                print(error.localizedDescription)
                self.showAlert(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
                self.removeLoader()
            }
        }
    }
    
    
}
