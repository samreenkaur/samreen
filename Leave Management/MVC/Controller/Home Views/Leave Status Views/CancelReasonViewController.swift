//
//  CancelReasonViewController.swift
//  Leave Management
//
//  Created by osx on 06/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import Alamofire

class CancelReasonViewController: BaseViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var btnOption1: UIButton!
    @IBOutlet weak var btnOption2: UIButton!
    @IBOutlet weak var btnOption3: UIButton!
    @IBOutlet weak var btnOption4: UIButton!
    
    //MARK:- Variables
    var selectedButton = UIButton()
    var leaveDetails = LeavesModel()
    
    
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
    
    //MARK:- API Hit
    private func apiHit(){
        
        let url = APIUrl.base + APIUrl.cancelLeave
        let parameters : Parameters = ["leaveId": self.leaveDetails.id]
        
        let headers: HTTPHeaders = ["Authorization": user.tokenType + " " + user.accessToken]
        
        self.addLoader()
        print("\n\n\nAPI::: \(url) \nParamteres::: \(parameters) \nHeaders::: \(headers)")
        Alamofire.request(url, method: .post, parameters: parameters,encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            switch response.result
            {
            case .success(_):
                
                if let data = response.result.value as? [String:AnyObject]
                {
                    
                    self.removeLoader()
                    let responseData = ResponseModel.init(data)
                    if responseData.success == 1
                    {
                        let alert = UIAlertController(title: "Success", message: "Your have successfully cancelled the leave.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
                            self.navigationController?.popViewController(animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                    else if responseData.sessionExpired
                    {
                        self.refreshTokenApiHit()
                    }
                    else
                    {
                        self.showAlert(title: "Error", message: responseData.errorMessage, actionTitle: "Ok")
                    }
                }
                else
                {
                    self.showAlert(title: "Error", message: "", actionTitle: "Ok")
                }
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
    
}
