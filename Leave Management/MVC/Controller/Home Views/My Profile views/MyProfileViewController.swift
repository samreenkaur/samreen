//
//  MyProfileViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDesignation: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var swNotification: UISwitch!
    

    //MARK:- Variables
    

    //MARK:- Lifecycle func

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.callViewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {

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
        
        self.navigationItem.title = "My Profile"
    }
    
    //MARK:- Button Actions
    @IBAction func switchNotification(_ sender: UISwitch) {
        
    }
    @IBAction func btnEditProfileAction(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: kEditProfileViewController) as? EditProfileViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnChangePasswordAction(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: kChangePasswordViewController) as? ChangePasswordViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnLogoutAction(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Are you sure?", message: "You want to Log out.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.navigationController?.popToRootViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }

}
