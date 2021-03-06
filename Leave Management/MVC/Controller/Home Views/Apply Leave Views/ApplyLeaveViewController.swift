//
//  ApplyLeaveViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import Alamofire

class ApplyLeaveViewController: BaseViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var btnLeaveType: UIButton!
    @IBOutlet weak var btnShiftType: UIButton!
    @IBOutlet weak var viewDate: UIView!
    @IBOutlet weak var viewDateHeight: NSLayoutConstraint!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var btnEndDate: UIButton!
    @IBOutlet weak var iconEndDate: UIImageView!
    @IBOutlet weak var lblTotalDays: UILabel!
    @IBOutlet weak var lblSmartNotes: UILabel!
    @IBOutlet weak var btnAttachment: UIButton!
    @IBOutlet weak var btnAttachmentIcon: UIButton!
    
    @IBOutlet weak var viewPickers: UIView!
    //    @IBOutlet weak var viewPickerContainer: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datepickerView: UIDatePicker!
    
    
    //MARK:- Variables
    var textViewPlaceholder = "Type your reason here..."
    var pickerType = 0 // 0 - Leave type, 1 - Shift type , 2 - Start Date pickers, 3 - End Date Picker
    var selectedLeaveType = 0
    var selectedShiftType = 2
    var pickerLeaveType = ["Annual Leave", "Medical Leave","Emergency Leave","Other"]
    var pickerShiftType = ["Short","Half Day", "Full Day","Multiple Days"]
    var pickerArr = [String]()
    var startDate = Date()
    var endDate = Date()
    var pickerController = UIImagePickerController()
    var imageUploaded = UIImage()
    
    
    //MARK:- Lifecycle func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.callViewDidLoad()
        self.setupToHideKeyboardOnTapOnView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK:- main funcs
    private func callViewDidLoad()
    {
        self.pickerController.delegate = self
        self.textView.delegate = self
        self.textView.text = self.textViewPlaceholder
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        self.datepickerView.date = Date()
        self.viewPickers.isHidden = true
        //        self.viewPickerContainer.isHidden = true
        self.btnLeaveType.setTitle(self.pickerLeaveType[self.selectedLeaveType], for: .normal)
        self.btnShiftType.setTitle(self.pickerShiftType[self.selectedShiftType], for: .normal)
        self.viewDate.isHidden = true
        self.viewDateHeight.constant = 0
        self.checkForShiftType()
        self.getUserData()
    }
    private func callViewWillAppear()
    {
        
    }
    
    private func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationItem.title = "Apply Leave"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_leave_type"), style: .plain, target: self, action: #selector(self.rightBarButtonAction(_:)))
            //UIBarButtonItem(title: "info", style: .plain, target: self, action: #selector(self.rightBarButtonAction(_:)))
    }
    
    @objc func rightBarButtonAction(_ sender: Any){
        if let vc = self.storyboard?.instantiateViewController(identifier: kWebViewController) as? WebViewController
        {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //MARK:- Button Actions
    @IBAction func btnLeaveTypeAction(_ sender: UIButton) {
        self.pickerType = 0
        self.viewPickers.isHidden = false
        self.pickerView.isHidden = false
        self.datepickerView.isHidden = true
        self.pickerArr = self.pickerLeaveType
        self.pickerView.reloadAllComponents()
        if let index = self.pickerArr.firstIndex(where: { $0 == sender.title(for: .normal) })
        {
            self.pickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    @IBAction func btnShiftTypeAction(_ sender: UIButton) {
        self.pickerType = 1
        self.pickerView.isHidden = false
        self.datepickerView.isHidden = true
        self.viewPickers.isHidden = false
        self.pickerArr = self.pickerShiftType
        self.pickerView.reloadAllComponents()
        if let index = self.pickerArr.firstIndex(where: { $0 == sender.title(for: .normal) })
        {
            self.pickerView.selectRow(index, inComponent: 0, animated: false)
        }
        
    }
    
    @IBAction func btnSelectStartDateAction(_ sender: UIButton) {
        self.pickerType = 2
        //        self.datepickerView.datePickerMode = .date
        self.datepickerView.minimumDate = Date()
        self.datepickerView.maximumDate = nil
        self.pickerView.isHidden = true
        self.datepickerView.isHidden = false
        self.viewPickers.isHidden = false
        self.lblTotalDays.text = "Duration"
        let date = self.dateSelected(self.startDate)
        self.btnStartDate.setTitle(date, for: .normal)
        
    }
    @IBAction func btnSelectEndDateAction(_ sender: UIButton) {
        self.pickerType = 3
        //        self.datepickerView.datePickerMode = .date
        self.datepickerView.minimumDate = self.startDate
        let maxiDate = Calendar.current.date(byAdding: .hour, value: 24, to: self.startDate)
        switch self.selectedShiftType
        {
        case 0,1: self.datepickerView.maximumDate = maxiDate
            break
        case 2: self.datepickerView.maximumDate = nil
            break
        case 3: self.datepickerView.maximumDate = nil
        self.datepickerView.minimumDate = Calendar.current.date(byAdding: .hour, value: 2, to: self.startDate)
            break
        default: break
        }
        self.pickerView.isHidden = true
        self.datepickerView.isHidden = false
        self.viewPickers.isHidden = false
        self.lblTotalDays.text = "Duration"
        
    }
    
    
    @IBAction func btnDonePickerAction(_ sender: UIButton) {
        self.viewPickers.isHidden = true
        let row = self.pickerView.selectedRow(inComponent: 0)
        switch self.pickerType
        {
        case 0:
            self.btnLeaveType.setTitle(self.pickerArr[row], for: .normal)
            self.selectedLeaveType = self.pickerView.selectedRow(inComponent: 0)
            break
        case 1:
            self.btnShiftType.setTitle(self.pickerArr[row], for: .normal)
            self.selectedShiftType = self.pickerView.selectedRow(inComponent: 0)
            self.checkForShiftType()
            self.smartChecks()
            break
        case 2:
            
            let date = self.dateSelected(self.datepickerView.date)
            self.startDate = self.datepickerView.date
            self.checkForShiftType()
            self.btnStartDate.setTitle(date, for: .normal)
            self.smartChecks()
            break
            
        case 3:
            self.checkForShiftType()
            let date = self.dateSelected(self.datepickerView.date)
            self.endDate = self.datepickerView.date
            self.btnEndDate.setTitle(date, for: .normal)
            self.calculateDays()
            self.smartChecks()
            break
        default:
            break
        }
    }
    @IBAction func btnCancelPickerAction(_ sender: UIButton) {
        self.viewPickers.isHidden = true
        self.calculateDays()
        
    }
    
    @IBAction func btnUploadAttachmentAction(_ sender: UIButton) {
        self.showActionSheet(pickerDelegate: self)
    }
    @IBAction func btnDeleteAttachmentAction(_ sender: UIButton) {
        if sender.tag == 0
        {
            self.showActionSheet(pickerDelegate: self)
        }
        else
        {
            sender.tag = 0
            sender.setImage(UIImage(named: "icon_attechment"), for: .normal)
            self.btnAttachment.setTitle("Attach here", for: .normal)
            self.btnAttachment.setTitleColor(Colors.themeDarkGray, for: .normal)

        }
        
    }
    
    @IBAction func btnApplyAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let reason = self.trimString(self.textView.text ?? "")
        if self.selectedShiftType == 3 && self.lblTotalDays.text?.contains("Duration") ?? false{
            self.showAlert(title: "Warning", message: "Please select end date.", actionTitle: "Ok")
        }else if !self.isValidText(reason) || reason == self.textViewPlaceholder{
            self.showAlert(title: "Warning", message: "Please enter reason for leave.", actionTitle: "Ok")
        }else{
            
            if imageUploaded != UIImage(){
                uploadImageApiHit()
            }
            else
            {
                self.apiHit("")
            }
        }
    }
    
    
    //MARK: - funcs
    func checkForShiftType(){
        let date = self.dateSelected(self.startDate)
        self.btnStartDate.setTitle(date, for: .normal)
        self.lblSmartNotes.text = ""
        switch self.selectedShiftType{
        case 0 :
            self.viewDateHeight.constant = 85
            self.viewDate.isHidden = false
            self.btnEndDate.isUserInteractionEnabled = false
            self.btnEndDate.setTitleColor(Colors.themeLightGray, for: .normal)
            self.datepickerView.datePickerMode = .dateAndTime
            let maxiDate = Calendar.current.date(byAdding: .hour, value: 2, to: self.startDate) ?? Date()
            self.btnEndDate.setTitle(self.dateSelected(maxiDate), for: .normal)
            self.endDate = maxiDate
            self.iconEndDate.tintColor = Colors.themeLightGray
//            self.iconEndDate.image = Images.calenderDateDisabled
            break
        case 1:
            self.viewDateHeight.constant = 85
            self.viewDate.isHidden = false
            self.btnEndDate.isUserInteractionEnabled = false
            self.btnEndDate.setTitleColor(Colors.themeLightGray, for: .normal)
            self.datepickerView.datePickerMode = .dateAndTime
            let maxiDate = Calendar.current.date(byAdding: .hour, value: 4, to: self.startDate) ?? Date()
            self.endDate = maxiDate
            self.btnEndDate.setTitle(self.dateSelected(maxiDate), for: .normal)
            self.iconEndDate.tintColor = Colors.themeLightGray
            //            self.iconEndDate.image = Images.calenderDateDisabled
            break
        case 2 :
            self.viewDateHeight.constant = 0
            self.viewDate.isHidden = true
            self.datepickerView.datePickerMode = .date
            self.btnEndDate.isUserInteractionEnabled = false
            self.datepickerView.maximumDate = nil
            self.iconEndDate.tintColor = Colors.themeLightGray
            //            self.iconEndDate.image = Images.calenderDateDisabled
            break
        case 3:
            self.viewDateHeight.constant = 85
            self.viewDate.isHidden = false
            self.btnEndDate.isUserInteractionEnabled = true
            self.btnEndDate.setTitleColor(Colors.themeDarkGray, for: .normal)
            self.datepickerView.datePickerMode = .dateAndTime
            self.endDate = Date()
            self.btnEndDate.setTitle("End Date (Including)", for: .normal)
            self.iconEndDate.tintColor = Colors.themeColor
            //            self.iconEndDate.image = Images.calenderDate
            break
        default:
            break
        }
        self.calculateDays()
    }
    
    func dateSelected(_ sender: Date) -> String {
        let formatter = dateFormatter
        switch self.selectedShiftType{
        case 0,1,3: formatter.dateFormat = "dd MMM yyyy HH:mm a"
            break
        case 2: formatter.dateFormat = "dd MMM yyyy"
            break
        default: break
        }
        let str = formatter.string(from: sender)
        return str
    }
    func calculateDays(){
        switch self.selectedShiftType{
        case 0,1:
            let diff = Calendar.current.dateComponents([.hour, .minute], from: self.startDate, to: self.endDate)
            let hours = diff.hour ?? 0
            let mint = diff.minute ?? 0
            self.lblTotalDays.text = (hours > 0) ? ((mint > 0) ? "\(hours) Hours, \(mint) minutes" : "\(hours) Hours") : ((mint > 0) ? "\(mint) minutes" : "Duration")
            break
        case 2: self.lblTotalDays.text = "Duration"
            break
        case 3:
            let days = Calendar.current.dateComponents([.day], from: self.startDate, to: self.endDate).day ?? 0
            self.lblTotalDays.text = (days>0) ?  "\(days+1) Days" : "Duration"
            break
        default: break
        }
    }
    
    //MARK: - smart checks
    private func smartChecks(){
        let getHolidaysList = self.getHolidaysModelFromRealm()
        
        
        let filter = getHolidaysList.filter({ $0.date ?? Date() >= Date() && ((self.selectedShiftType != 3 && ($0.date ?? Date() >= self.startDate.getOnlyDate().addingTimeInterval(-60*60*24)) && ($0.date ?? Date() <= self.startDate.getOnlyDate().addingTimeInterval(60*60*24))) || (self.selectedShiftType == 3 && ( ($0.date ?? Date() >= self.startDate.getOnlyDate().addingTimeInterval(-60*60*24)) && ($0.date ?? Date() <= self.endDate.getOnlyDate().addingTimeInterval(60*60*24))))) })
        if filter.count > 0{
            var dates = ""
            for i in filter
            {
                dates += " \(i.date?.convertDateToString(dataFormat: "dd-MMM-yyyy") ?? ""),"
            }
            self.lblSmartNotes.text = "\n There is an official holiday on\(dates.dropLast()). "
        }else
        {
            self.lblSmartNotes.text = ""
        }
    }
    
    
    
    //MARK:- API Hit
    private func apiHit(_ uploadImageUrl: String){
        let desc = self.trimString(self.textView.text ?? "")
        
        let url = APIUrl.base + APIUrl.applyLeave
        var parameters : Parameters = ["LeaveTypeId": self.selectedLeaveType + 1 ,"ShiftTypeId": self.selectedShiftType + 1 ,"FromDate": self.btnStartDate.title(for: .normal) ?? "" ,"ToDate": self.btnEndDate.title(for: .normal) ?? "" ,"Reason": desc ,"LeaveStatusId": 1]
        if !uploadImageUrl.isEmpty
        {
            parameters["Documents[0].ImageUrl"] = uploadImageUrl
        }
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
                        let alert = UIAlertController(title: "Success", message: "Your have successfully applied for leave.", preferredStyle: .alert)
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
                self.showAlert(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
            }
        }
    }
    private func uploadImageApiHit(){
        
        let image = self.imageUploaded
        AWSS3Manager.shared.uploadImage(image: image, progress: {[weak self] ( uploadProgress) in
            
            guard let strongSelf = self else { return }
            strongSelf.addLoader()
            print(uploadProgress)
        }) {[weak self] (uploadedFileUrl, error) in
            
            guard let strongSelf = self else { return }
            if let finalPath = uploadedFileUrl as? String { // 3
                strongSelf.apiHit(finalPath)
            } else {
                print("\(String(describing: error?.localizedDescription))") // 4
            }
        }
        
    }
    
}
extension ApplyLeaveViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate
{
    //MARK:- ImageViewController delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imageName = "image.png"
        
        if let img = info[.editedImage] as? UIImage{
            self.imageUploaded = img
            self.btnAttachment.setTitle(imageName, for: .normal)
            self.btnAttachment.setTitleColor(Colors.themeLink, for: .normal)
            self.btnAttachmentIcon.tag = 1
            self.btnAttachmentIcon.setImage(UIImage(named: "icon_delete"), for: .normal)
        }else if let img = info[.originalImage] as? UIImage{
            self.imageUploaded = img
            self.btnAttachment.setTitle(imageName, for: .normal)
            self.btnAttachment.setTitleColor(Colors.themeLink, for: .normal)
            self.btnAttachmentIcon.tag = 1
            self.btnAttachmentIcon.setImage(UIImage(named: "icon_delete"), for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
extension ApplyLeaveViewController  : UITextViewDelegate {
    //MARK:- TextView delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.textViewPlaceholder
        {
            textView.text = ""
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines) == ""
        {
            textView.text = self.textViewPlaceholder
        }
    }
    func textViewDidChange(_ textView: UITextView) {
        textView.sizeToFit()
    }
}

extension ApplyLeaveViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    //MARK:- PickerView delegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerArr.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerArr[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //        switch self.pickerType
        //        {
        //        case 0:
        //            self.btnLeaveType.setTitle(self.pickerArr[row], for: .normal)
        //        case 1:
        //            self.btnShiftType.setTitle(self.pickerArr[row], for: .normal)
        //        default:
        //            break
        //        }
    }
    
    
}
