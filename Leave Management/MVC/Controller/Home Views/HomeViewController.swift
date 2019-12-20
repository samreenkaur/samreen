//
//  HomeViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class HomeViewController: BaseViewController {
    
    //MARK:- Variables
    var autoLogin = false
    
    
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
    
    //MARK:- main funcs
    private func callViewDidLoad()
    {
        self.getUserData()
        if autoLogin
        {
//            self.apiTokenHit()
        }
    }
    private func callViewWillLoad()
    {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationItem.title = ""
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_notifaction"), style: .plain, target: self, action: #selector(self.rightBarButtonAction(_:)))
    }
    
    @objc func rightBarButtonAction(_ sender: Any){
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: kNotificationsViewController) as? NotificationsViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //MARK:- Button Actions
    @IBAction func btnApplyLeaveAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: kApplyLeaveViewController) as? ApplyLeaveViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnHolidayAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: kHolidaysViewController) as? HolidaysViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnLeaveStatusAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: kLeaveStatusViewController) as? LeaveStatusViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnMyProfileAction(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: kMyProfileViewController) as? MyProfileViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- API Hit
    private func apiTokenHit(){
        
        let url = APIUrl.base + APIUrl.token
        let parameters : Parameters = ["grant_type": "refresh_token","client_id": "LeaveManagement", "client_secret": "leaveManagement!46#","refresh_token": user.refreshToken]
        
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
                    }
                }
                else
                {
                    self.showAlert(title: "Error", message: "", actionTitle: "Ok")
                }
                
                break
            case .failure(let error):
                print(error.localizedDescription)
                self.removeLoader()
            }
        }
        
    }
    
    
}
