//
//  MyProfileViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import SDWebImage
import SimpleImageViewer


class MyProfileViewController: BaseViewController{
    
    
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
        super.viewWillAppear(animated)
        callViewWillAppear()
    }
    
    
    //MARK:- main funcs
    private func callViewDidLoad()
    {
        self.addTapGesture()
    }
    private func callViewWillAppear()
    {
        self.getUserData()
        
        if !user.id.isEmpty
        {
            self.lblName.text = user.fullName
            self.lblEmail.text = user.email
            self.lblPhoneNumber.text = user.phoneNumber
            self.lblDesignation.text = user.designation
            if user.profilePic.isEmpty{
                self.imgUser.image = Images.userPlaceholder
            }else{
                self.imgUser.sd_setImage(with: URL(string: user.profilePic), placeholderImage: Images.userPlaceholder)
            }
        }
    }
    
    private func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationItem.title = "My Profile"
    }
    //MARK:- Tap Gesture
    private func addTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        self.imgUser.isUserInteractionEnabled = true
        self.imgUser.addGestureRecognizer(tap)
    }
    
    @objc func imageTapped(_ sender : UITapGestureRecognizer){
            let configuration = ImageViewerConfiguration { config in
                config.imageView = self.imgUser
            }

            let imageViewerController = ImageViewerController(configuration: configuration)

            present(imageViewerController, animated: true)
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
    @IBAction func btnLeavePoliciesAction(_ sender: UIButton) {
        if let vc = self.storyboard?.instantiateViewController(identifier: kWebViewController) as? WebViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func btnLogoutAction(_ sender: UIButton) {
        self.showLogoutAlert()
    }
    
}
