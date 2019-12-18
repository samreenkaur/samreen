//
//  LoginViewController.swift
//  Leave Management
//
//  Created by osx on 04/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import Alamofire
import Crashlytics
import RealmSwift

class LoginViewController: BaseViewController , UITextFieldDelegate {
    
    
    //MARK:- Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var btnSignin: UIButton!
    @IBOutlet weak var tfEmail: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var tfPassword: SkyFloatingLabelTextFieldWithIcon!
    
    
    //MARK:- Variables
    
    
    //MARK:- Lifecycle func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.callViewDidLoad()
        self.ifuserAlreadyExists()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tfEmail.text = ""
        self.tfPassword.text = ""
        
    }
    
    
    //MARK:- main funcs
    private func callViewDidLoad()
    {
        
        self.tfEmail.delegate = self
        self.tfPassword.delegate = self
        
        self.setupToHideKeyboardOnTapOnView()
        //Crashlytics.sharedInstance().crash()
        
    }
    private func callViewWillLoad()
    {
        
    }
    
    private func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func ifuserAlreadyExists(){
        let model = UserModel().getUserloggedIn() ?? UserModel()
        if model.id>0{
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: kHomeViewController) as? HomeViewController
            {
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }
    }
    
    //MARK:- TextField Delegate func
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == tfEmail
        {
            tfPassword.becomeFirstResponder()
        }else if textField == tfPassword
        {
            tfPassword.resignFirstResponder()
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
    @IBAction func btnSignInPasswordAction(_ sender: UIButton) {
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
    @IBAction func btnForgotPassword(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: kForgotPasswordViewController) as? ForgotPasswordViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    @IBAction func btnLoginAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let email = self.trimString(self.tfEmail.text ?? "")
        let password = self.trimString(self.tfPassword.text ?? "")
        
        if !self.isValidText(email){
            self.showAlert(title: "Warning", message: "Please enter your email.", actionTitle: "Ok")
        }else if !self.isValidEmail(email){
            self.showAlert(title: "Warning", message: "Please enter valid email.", actionTitle: "Ok")
        }else if !self.isValidText(password){
            self.showAlert(title: "Warning", message: "Please enter your password.", actionTitle: "Ok")
        }else{
            self.apiHit()
        }
    }
    
    
    @IBAction func btnSignUpAction(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: kSignUpViewController) as? SignUpViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- API Hit
    private func apiHit(){
        let email = self.trimString(self.tfEmail.text ?? "")
        let password = self.trimString(self.tfPassword.text ?? "")
        
//        guard let url = URL(string: loginUrl) else {
//                return
//        }
        let parameters : Parameters = ["email": email, "password": password]
        
        Alamofire.request(loginUrl, method: .post, parameters: parameters, encoding: URLEncoding.default).responseJSON { (response) in
            switch response.result
            {
            case .success(_):
//                do{
//                    let json = try JSONSerialization.data(withJSONObject: response.result, options: .prettyPrinted)
                    let model = UserModel.init(dict: response.result.value as! [String : AnyObject])
                    do {
                        let realm = try Realm()
                        try realm.write {
                            realm.add(model, update: .all)
                        }
                    } catch let error as NSError {
                        print(error)
                    }
//                }
//                catch
//                {
//                    print("error")
//                }
                break
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
        
        //
        //        API().post(url: url, parameters: ["email": email, "password": password], token: "", success: { (user) in
        //            DispatchQueue.main.async {
        ////                let user = try! JSONDecoder().decode(User.self, from: user)
        //                let model = UserModel.init(dict: userDataDict)
        //                RealmDatabase.shared.add(object: model)
        //                if let vc = self.storyboard?.instantiateViewController(withIdentifier: kHomeViewController) as? HomeViewController
        //                {
        //                    self.navigationController?.pushViewController(vc, animated: true)
        //                }
        //            }
        //        }) { (error) in
        //            self.showAlert(title: "Error", message: error, actionTitle: "Ok")
        //        }
        
        
        //
        //        let model = UserModel().getUserloggedIn()
        //            model?.email = email
        //do {
        //    let realm = try Realm()
        //    try realm.write {
        //        realm.add(model, update: .all)
        //    }
        //} catch let error as NSError {
        //    print(error)
        //}
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: kHomeViewController) as? HomeViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
}

