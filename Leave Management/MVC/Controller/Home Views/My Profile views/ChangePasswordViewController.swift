//
//  ChangePasswordViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ChangePasswordViewController: BaseViewController, UITextFieldDelegate {
    
    
    //MARK:- Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tfOldPassword: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var tfNewPassword: SkyFloatingLabelTextFieldWithIcon!
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
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    //MARK:- main funcs
    private func callViewDidLoad()
    {
        self.tfOldPassword.delegate = self
        self.tfNewPassword.delegate = self
        self.tfConfirmPassword.delegate = self
        
        self.setupToHideKeyboardOnTapOnView()
        
    }
    private func callViewWillLoad()
    {
        
    }
    
    private func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = "Change Password"
    }
    
    
    //MARK:- TextField Delegate func
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfOldPassword
        {
            tfNewPassword.becomeFirstResponder()
        }else if textField == tfNewPassword
        {
            tfConfirmPassword.becomeFirstResponder()
        }else if textField == tfConfirmPassword
        {
            tfConfirmPassword.resignFirstResponder()
        }
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField.text?.count ?? 0 >= 50 && string != ""{
            return false
        }
        return true
    }
    
    
    //MARK:- Button Actions
    @IBAction func btnResetPasswordAction(_ sender: UIButton) {
        let password = self.trimString(self.tfOldPassword.text ?? "")
        let newpassword = self.trimString(self.tfNewPassword.text ?? "")
        let confirmPassword = self.trimString(self.tfConfirmPassword.text ?? "")
        
        if !self.isValidText(password){
            self.showAlert(title: "Warning", message: "Please enter your last password.", actionTitle: "Ok")
        }else if !self.isValidText(newpassword){
            self.showAlert(title: "Warning", message: "Please enter your new password.", actionTitle: "Ok")
        }else if !self.isValidText(confirmPassword){
            self.showAlert(title: "Warning", message: "Please confirm your password.", actionTitle: "Ok")
        }else if newpassword != confirmPassword{
            self.showAlert(title: "Warning", message: "Password doesn't match.", actionTitle: "Ok")
        }else{
            self.apiHit()
        }
        
    }
    //MARK:- API Hit
    private func apiHit(){
        let alert = UIAlertController(title: "Success", message: "Your password has been successfully updated.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
