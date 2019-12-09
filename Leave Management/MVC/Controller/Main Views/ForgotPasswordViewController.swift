//
//  ForgotPasswordViewController.swift
//  Leave Management
//
//  Created by osx on 04/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextFieldWithIcon!
    
    //MARK:- Variables
    
    
    //MARK:- Lifecycle func
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavigationBar()
        self.callViewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK:- main funcs
    private func callViewDidLoad()
    {
        self.setupToHideKeyboardOnTapOnView()
    }
    private func callViewWillLoad()
    {
        
    }
    
    private func setUpNavigationBar(){
           self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
           self.navigationController?.navigationBar.shadowImage = UIImage()
           self.navigationController?.navigationBar.isTranslucent = true
            self.navigationItem.title = ""
    }
       
    
    //MARK:- Button Actions
    
    
    @IBAction func btnResetPasswordAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let email = self.tfEmail.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if email?.isEmpty ?? false{
            let alert = UIAlertController(title: "Warning", message: "Enter email", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Success", message: "An email has been sent to \(email ?? "this email address") for further instructions.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
                self.navigationController?.popViewController(animated: true)
            }))
            self.present(alert, animated: true, completion: nil)
        }
      
    }

}
