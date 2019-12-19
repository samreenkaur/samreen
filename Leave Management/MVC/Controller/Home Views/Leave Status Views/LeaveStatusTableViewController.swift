//
//  LeaveStatusTableViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import Alamofire



class LeaveStatusTableViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblLeaveBalance: UILabel!
    
    //MARK:- Variables
    var status = 1// "Approved", "Unapproved","Cancelled", "Pending"
    var arrList = [LeavesModel]()
    
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
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getUserData()
        self.apiHit()
    }
    private func callViewWillLoad()
    {
        switch self.status
        {
        case 1:
            self.tableView.tableHeaderView = nil
            break
        case 2:
            self.tableView.tableHeaderView = nil
            break
        case 3:
            self.tableView.tableHeaderView = nil
            break
        case 4:
            self.tableView.tableHeaderView = self.headerView
            break
        default:
            break
        }
    }
    
    private func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationItem.title = "Leave Status"
    }
    
    //MARK:- TableView Delegate and Datasources
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.arrList.count
        if count > 0 {
            self.tableView.isHidden = false
        }else{
            self.tableView.isHidden = true
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kLeaveStatusTableViewCell, for: indexPath) as! LeaveStatusTableViewCell
        cell.btnCancel.tag = indexPath.row
        cell.lblReason.text = "I want to go for a trip and will not be able to attend the office for a week.  go for a trip and will not be able to attend the office for a week. "
        cell.btnCancel.addTarget(self, action: #selector(self.cancelButtonAction(_:)), for: .touchUpInside)
        switch self.status
        {
        case 1:
            cell.lblStatus.text = "Approved"
            cell.lblStatus.textColor = Colors.themeGreen
            cell.btnCancel.isHidden = true
            cell.btnCancelHeight.constant = 0
            cell.viewResponseReason.isHidden = true
            cell.viewResponseReasonHeight.constant = 0
            break
            
        case 2:
            cell.lblStatus.text = "Unapproved"
            cell.lblStatus.textColor = Colors.themeColor
            cell.btnCancel.isHidden = true
            cell.btnCancelHeight.constant = 0
            cell.viewResponseReason.isHidden = false
            cell.viewResponseReasonHeight.constant = cell.lblResponseReason.frame.size.height + 15
            break
        case 3:
            cell.lblStatus.text = "Cancelled"
            cell.lblStatus.textColor = Colors.themeRed
            cell.btnCancel.isHidden = true
            cell.btnCancelHeight.constant = 0
            cell.viewResponseReason.isHidden = false
            cell.viewResponseReasonHeight.constant = cell.lblResponseReason.frame.size.height + 15
            break
        case 4:
            cell.lblStatus.text = "Pending"
            cell.lblStatus.textColor = Colors.themeYellow
            cell.btnCancel.isHidden = false
            cell.btnCancelHeight.constant = 50
            cell.viewResponseReason.isHidden = true
            cell.viewResponseReasonHeight.constant = 0
            break
        default:
            break
        }
        cell.viewAttachmentsHeight.constant = cell.lblAttachments.frame.size.height + 15
        //        if thereIsAttachments{
        //            cell.viewAttachments.isHidden = false
        //            cell.viewAttachmentsHeight.constant = cell.lblAttachments.frame.size.height + 15
        //        }else{
        //            cell.viewAttachments.isHidden = true
        //            cell.viewAttachmentsHeight.constant = 0
        //        }
        
        return cell
    }
    
    
    
    @objc func cancelButtonAction(_ sender : UIButton){
        let index = sender.tag
        print(index)
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: kCancelReasonViewController) as? CancelReasonViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    //MARK:- API Hit
    private func apiHit(){
        
        let url = APIUrl.base + APIUrl.getAllLeaves + "?leaveStatusId=\(self.status)"
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
                    if let success = data["Success"] as? Int, success == 1,let responsedata = data["Data"] as? [[String:AnyObject]]
                    {
                        let model : [LeavesModel] = responsedata.map(LeavesModel.init)
                        self.arrList = model
                        self.tableView.reloadData()
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
            case .failure(let error):
                self.removeLoader()
                print(error.localizedDescription)
                
            }
        }
        //        user.realm?.beginWrite()
        //        user.fullName = name
        //        user.email = email
        //        user.phoneNumber = phoneNumber
        //        user.designation = designation
        //        do {
        //            try user.realm?.commitWrite()
        //        } catch {
        //            print(error.localizedDescription)
        //        }
        //        self.navigationController?.popViewController(animated: true)
    }
}


