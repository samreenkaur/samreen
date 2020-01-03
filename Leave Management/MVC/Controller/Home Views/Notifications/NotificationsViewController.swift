//
//  NotificationsViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import Alamofire


class NotificationsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!

    //MARK:- Variables
    var arrList = [NotificationsModel]()
    
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
    
    
    //MARK:- main funcs
    private func callViewDidLoad()
    {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.apiHit()
    }
    private func callViewWillAppear()
    {
        
    }
    
    private func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationItem.title = "Notifications"
    }
    
    //MARK:- TableView Delegate and Datasources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = 10//self.arrList.count
        if count > 0 {
            self.lblNoData.isHidden = true
            self.tableView.isHidden = false
        }else{
            self.lblNoData.isHidden = false
            self.tableView.isHidden = true
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kNotificationTableViewCell, for: indexPath) as! NotificationTableViewCell
        
        let month: String = "\(Month.init(rawValue: indexPath.row + 1)!)"
        cell.lblTitle.text = "Your leave for \(Int(ceil(Double(indexPath.row+1) * 10 / 15))) \(month), 2019 is unapproved"
//        let data = self.arrList[indexPath.row]
//        cell.lblTitle.text = data.title
//        cell.lblTime.text = data.time
        return cell
    }
    
    
    //MARK:- API Hit
        private func apiHit(){
            
            
           
            let url = APIUrl.base + APIUrl.getAllNotifications
            let parameters : Parameters = [:]
            
            let headers: HTTPHeaders = ["Authorization": user.tokenType + " " + user.accessToken]
            
            self.addLoader()
            print("\n\n\nAPI::: \(url) \nParamteres::: \(parameters) \nHeaders::: \(headers)")
            Alamofire.request(url, method: .get, parameters: parameters,encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
                switch response.result
                {
                case .success(_):
                    self.removeLoader()
                    
                    if let data = response.result.value as? [String:AnyObject]
                    {
                        self.removeLoader()
                        let responseData = ResponseModel.init(data)
                        if responseData.success == 1
                        {
                            let model : [NotificationsModel] = responseData.dataArray.map(NotificationsModel.init)
                            self.arrList = model
                            self.tableView.reloadData()
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
                    self.removeLoader()
                    print(error.localizedDescription)
                    self.showAlert(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
                }
            }
        }
    }

