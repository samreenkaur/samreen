//
//  LeaveStatusTableViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire
import SimpleImageViewer


class LeaveStatusTableViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
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
            self.lblNoData.isHidden = true
            self.tableView.isHidden = false
        }else{
            self.lblNoData.isHidden = false
            self.tableView.isHidden = true
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kLeaveStatusTableViewCell, for: indexPath) as! LeaveStatusTableViewCell
        let data = self.arrList[indexPath.row]
        let leavetype: String = "\(LeaveType.init(rawValue: data.leaveTypeId) ?? LeaveType.init(rawValue: 1)!)".capitalized
        let shifttype: String = "\(ShiftType.init(rawValue: data.shiftTypeId) ?? ShiftType.init(rawValue: 1)!)".capitalized
        cell.lblReason.text = data.reason
        cell.lblLeaveType.text = "\(leavetype) Leave"
        cell.lblShiftType.text = "Shift : \(shifttype)"
        cell.lblDate.text = "\(data.fromDateFormatted) - \(data.toDateFormatted)"
        if data.shiftTypeId == 3
        {
            cell.lblDate.text = "\(data.fromDateFormatted)"
        }
        cell.lblAttachments.text = data.documents
        
        cell.btnCancel.tag = indexPath.row
        cell.lblAttachments.tag = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(self.cancelButtonAction(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        cell.lblAttachments.isUserInteractionEnabled = true
        cell.lblAttachments.addGestureRecognizer(tap)
        
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
        if !data.documents.isEmpty{
            cell.lblAttachments.textColor = Colors.themeLink
            cell.viewAttachments.isHidden = false
            cell.viewAttachmentsHeight.constant = cell.lblAttachments.frame.size.height + 15
        }else{
            cell.viewAttachments.isHidden = true
            cell.viewAttachmentsHeight.constant = 0
        }
        
        return cell
    }
    
    
    
    @objc func imageTapped(_ sender : UITapGestureRecognizer){
        let label:UILabel = (sender.view as! UILabel)
        let index = label.tag
        
        let imgView = UIImageView()
        imgView.sd_setImage(with: URL(string: self.arrList[index].documents), placeholderImage: UIImage())
        let configuration = ImageViewerConfiguration { config in
            config.image = imgView.image
        }
        
        let imageViewerController = ImageViewerController(configuration: configuration)
        
        present(imageViewerController, animated: true)
        
        
    }
    
    @objc func cancelButtonAction(_ sender : UIButton){
        let index = sender.tag
        print(index)
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: kCancelReasonViewController) as? CancelReasonViewController
        {
            vc.leaveDetails = self.arrList[sender.tag]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    //MARK:- API Hit
    private func apiHit(){
        
        
        var leaveStatusId = 1
        switch self.status
        {
        case 1:
            leaveStatusId = 2
            break
        case 2:
            leaveStatusId = 3
            break
        case 3:
            leaveStatusId = 4
            break
        case 4:
            leaveStatusId = 1
            break
        default:
            break
        }
        
        let url = APIUrl.base + APIUrl.getAllLeaves + "?leaveStatusId=\(leaveStatusId)"
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
                        let model : [LeavesModel] = responseData.dataArray.map(LeavesModel.init)
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
                
            }
        }
    }
}

