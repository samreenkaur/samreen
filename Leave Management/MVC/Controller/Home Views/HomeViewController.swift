//
//  HomeViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    //MARK:- Outlets
    
    
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

    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
    }
    
    //MARK:- main funcs
    private func callViewDidLoad()
    {
                
    }
    private func callViewWillLoad()
    {
        
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
}
