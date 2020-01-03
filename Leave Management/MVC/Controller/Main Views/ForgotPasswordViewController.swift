//
//  ForgotPasswordViewController.swift
//  Leave Management
//
//  Created by osx on 04/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire



class ForgotPasswordViewController: BaseViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var scrollView: UIScrollView!
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
        self.setupToHideKeyboardOnTapOnView()
    }
    private func callViewWillAppear()
    {
        
    }
    
    private func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = ""
    }
    
    
    //MARK:- Button Actions
    
    @IBAction func btnLoginAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnResetPasswordAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let email = self.trimString(self.tfEmail.text ?? "")
        
        if !self.isValidText(email){
            self.showAlert(title: "Warning", message: "Please enter your email.", actionTitle: "Ok")
        }else if !self.isValidEmail(email){
            self.showAlert(title: "Warning", message: "Please enter valid email.", actionTitle: "Ok")
        }else{
            self.apiHit()
        }
        
        
    }
    //MARK:- API Hit
    
    private func apiHit(){
        
        let email = self.trimString(self.tfEmail.text ?? "")
        
        let url = APIUrl.base + APIUrl.forgotPassword
        let parameters : Parameters = ["Email": email]
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
                        self.removeLoader()
                        let alert = UIAlertController(title: "Success", message: "An email has been sent to \(email) for further instructions.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
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
                
                break
            case .failure(let error):
                print(error.localizedDescription)
                self.showAlert(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
                self.removeLoader()
                
            }
        }
        
        
    }
    
}
