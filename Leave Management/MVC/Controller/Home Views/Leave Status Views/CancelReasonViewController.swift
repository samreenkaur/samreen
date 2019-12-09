//
//  CancelReasonViewController.swift
//  Leave Management
//
//  Created by osx on 06/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit

class CancelReasonViewController: UIViewController {

    //MARK:- Outlets
        @IBOutlet weak var btnOption1: UIButton!
    @IBOutlet weak var btnOption2: UIButton!
    @IBOutlet weak var btnOption3: UIButton!
    @IBOutlet weak var btnOption4: UIButton!
    
    //MARK:- Variables
        var selectedButton = UIButton()
        
        //MARK:- Lifecycle func
        override func viewDidLoad() {
            super.viewDidLoad()
            
            self.setUpNavigationBar()
            self.callViewDidLoad()
            
            
            // Do any additional setup after loading the view.
        }
        
        override func viewWillAppear(_ animated: Bool) {
            self.callViewWillLoad()
        }
        override func viewWillDisappear(_ animated: Bool) {

        }
        
        //MARK:- main funcs
        private func callViewDidLoad()
        {
            
        }
        private func callViewWillLoad()
        {
            self.selectedButton = self.btnOption1
        }
        
        private func setUpNavigationBar(){
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
            
            self.navigationItem.title = "Cancel Reason"
        }

    //MARK:- Button Actions
    @IBAction func btnSubmitAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnOptionsAction(_ sender: UIButton) {
        let btnArray: [UIButton] = [btnOption1,btnOption2,btnOption3,btnOption4]
        for btn in btnArray
        {
            if sender.tag == btn.tag{
                self.selectedButton = btn
                btn.setImage(UIImage(named: "icon_radio_btn_selected"), for: .normal)
            }else{
                btn.setImage(UIImage(named: "icon_radio_btn_unselescted"), for: .normal)
            }
        }
    }

}
