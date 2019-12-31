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
import ExpandableLabel


class LeaveStatusTableViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource, ExpandableLabelDelegate {
    
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var lblLeaveBalance: UILabel!
    
    //MARK:- Variables
    var status = 1// "Pending", "Approved", "Unapproved","Cancelled"
    var arrList = [LeavesModel]()
    var LeaveBalance = Int()
    
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
        self.lblLeaveBalance.text = "\(self.LeaveBalance)"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getUserData()
//        self.apiHit()
    }
    private func callViewWillLoad()
    {
        switch self.status
        {
        case 1:
            self.tableView.tableHeaderView = self.headerView
            break
        case 2:
            self.tableView.tableHeaderView = nil
            break
        case 3:
            self.tableView.tableHeaderView = nil
            break
        case 4:
            self.tableView.tableHeaderView = nil
            break
        default:
            break
        }
        self.apiHit()
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
        
        cell.lblReason.tag = indexPath.row
        cell.lblReason.text = data.reason
        cell.lblReason.numberOfLines = 3
        cell.lblReason.shouldCollapse = true
        cell.lblReason.shouldExpand = true
        cell.lblReason.delegate = self
         if data.reasonExpanded{
             cell.lblReason.collapsed = false
         }else{
             cell.lblReason.collapsed = true
         }
//        cell.lblReason.setLessLinkWith(lessLink: "Close", attributes: [NSAttributedString.Key.foregroundColor:UIColor.red], position: nil)
        
        cell.lblResponseReason.text = data.cancelreason
        cell.lblLeaveType.text = "\(leavetype) Leave"
        cell.lblShiftType.text = "Shift : \(shifttype)"
        cell.lblDate.text = "\(data.fromDateFormatted) - \(data.toDateFormatted)"
        if data.shiftTypeId == 3
        {
            cell.lblDate.text = "\(data.fromDateFormatted)"
        }
        let doc = data.documents
        let filename = (doc as NSString).lastPathComponent  // pdfURL is your file url
        cell.lblAttachments.text = filename//data.documents
        
        cell.btnCancel.tag = indexPath.row
        cell.lblAttachments.tag = indexPath.row
        cell.btnCancel.addTarget(self, action: #selector(self.cancelButtonAction(_:)), for: .touchUpInside)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        cell.lblAttachments.isUserInteractionEnabled = true
        cell.lblAttachments.addGestureRecognizer(tap)
        
        switch self.status
        {
        case 1:
            cell.lblStatus.text = "Pending"
            cell.lblStatus.textColor = Colors.themeYellow
            cell.btnCancel.isHidden = false
            cell.btnCancelHeight.constant = 50
            cell.viewResponseReason.isHidden = true
            cell.viewResponseReasonHeight.constant = 0
            break
        case 2:
            cell.lblStatus.text = "Approved"
            cell.lblStatus.textColor = Colors.themeGreen
            cell.btnCancel.isHidden = true
            cell.btnCancelHeight.constant = 0
            cell.viewResponseReason.isHidden = true
            cell.viewResponseReasonHeight.constant = 0
            break
            
        case 3:
            cell.lblStatus.text = "Unapproved"
            cell.lblStatus.textColor = Colors.themeColor
            cell.btnCancel.isHidden = true
            cell.btnCancelHeight.constant = 0
            cell.viewResponseReason.isHidden = false
            cell.viewResponseReasonHeight.constant = cell.lblResponseReason.frame.size.height + 15
            break
        case 4:
            cell.lblStatus.text = "Cancelled"
            cell.lblStatus.textColor = Colors.themeRed
            cell.btnCancel.isHidden = true
            cell.btnCancelHeight.constant = 0
            cell.viewResponseReason.isHidden = false
            cell.viewResponseReasonHeight.constant = cell.lblResponseReason.frame.size.height + 15
            break
        
        default:
            break
        }
        if !data.documents.isEmpty{
            cell.lblAttachments.textColor = Colors.themeLink
            cell.viewAttachments.isHidden = false
            cell.viewAttachmentsHeight.constant = 44//cell.lblAttachments.frame.size.height + 15
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
    
    //MARK: - Expandable label delegates
    func willExpandLabel(_ label: ExpandableLabel) {
        self.tableView.beginUpdates()
        
    }
    
    func didExpandLabel(_ label: ExpandableLabel) {
        let index = label.tag
        
        self.arrList[index].reasonExpanded = true
        self.tableView.endUpdates()
        self.tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }
    
    func willCollapseLabel(_ label: ExpandableLabel) {
        self.tableView.beginUpdates()
    }
    
    func didCollapseLabel(_ label: ExpandableLabel) {
        let index = label.tag
        self.arrList[index].reasonExpanded = false
        self.tableView.endUpdates()
    }
    
    
    //MARK:- API Hit
    private func apiHit(){
        
        
        let leaveStatusId = self.status//1
//        switch self.status
//        {
//        case 1:
//            leaveStatusId = 2
//            break
//        case 2:
//            leaveStatusId = 3
//            break
//        case 3:
//            leaveStatusId = 4
//            break
//        case 4:
//            leaveStatusId = 1
//            break
//        default:
//            break
//        }
        
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
                        
                        if let leaveBalance = data["LeaveBalance"] as? Int, self.status == 1{
                            self.LeaveBalance = leaveBalance
                            self.lblLeaveBalance.text = "\(self.LeaveBalance)"
                        }
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

