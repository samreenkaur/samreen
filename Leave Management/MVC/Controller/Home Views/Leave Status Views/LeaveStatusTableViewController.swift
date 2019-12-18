//
//  LeaveStatusTableViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit

class LeaveStatusTableViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblLeaveBalance: UILabel!
    
    //MARK:- Variables
    var status = 1// "Approved", "Unapproved","Cancelled", "Pending"
    
    
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
        return 10
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
            cell.lblStatus.textColor = themeColorGreen
            cell.btnCancel.isHidden = true
            cell.btnCancelHeight.constant = 0
            cell.viewResponseReason.isHidden = true
            cell.viewResponseReasonHeight.constant = 0
            break
            
        case 2:
            cell.lblStatus.text = "Unapproved"
            cell.lblStatus.textColor = themeColor
            cell.btnCancel.isHidden = true
            cell.btnCancelHeight.constant = 0
            cell.viewResponseReason.isHidden = false
            cell.viewResponseReasonHeight.constant = cell.lblResponseReason.frame.size.height + 15
            break
        case 3:
            cell.lblStatus.text = "Cancelled"
            cell.lblStatus.textColor = themeColorRed
            cell.btnCancel.isHidden = true
            cell.btnCancelHeight.constant = 0
            cell.viewResponseReason.isHidden = false
            cell.viewResponseReasonHeight.constant = cell.lblResponseReason.frame.size.height + 15
            break
        case 4:
            cell.lblStatus.text = "Pending"
            cell.lblStatus.textColor = themeColorYellow
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
}


