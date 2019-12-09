//
//  ApplyLeaveViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit

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
    @IBOutlet weak var lblTotalDays: UILabel!
    @IBOutlet weak var btnAttachment: UIButton!
    
    @IBOutlet weak var viewPickers: UIView!
    //    @IBOutlet weak var viewPickerContainer: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var datepickerView: UIDatePicker!
    
    
    //MARK:- Variables
    var textViewPlaceholder = "Type your reason here..."
    var pickerType = 0 // 0 - Leave type, 1 - Shift type , 2 - Start Date pickers, 3 - End Date Picker
    var selectedShiftType = 0
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
        self.addNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeNotifications()
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
        self.btnLeaveType.setTitle(self.pickerLeaveType[0], for: .normal)
        self.btnShiftType.setTitle(self.pickerShiftType[0], for: .normal)
        self.viewDate.isHidden = true
        self.viewDateHeight.constant = 0
        self.checkForShiftType()
    }
    private func callViewWillLoad()
    {
        
    }
    
    private func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationItem.title = "Apply Leave"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(self.rightBarButtonAction(_:)))
    }
    
    @objc func rightBarButtonAction(_ sender: Any){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- Notifications
    private func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    
    private func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
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
        case 2,3: self.datepickerView.maximumDate = nil
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
        case 1:
            self.btnShiftType.setTitle(self.pickerArr[row], for: .normal)
            self.selectedShiftType = self.pickerView.selectedRow(inComponent: 0)
            self.checkForShiftType()
        case 2:
            self.checkForShiftType()
            let date = self.dateSelected(self.datepickerView.date)
            self.startDate = self.datepickerView.date
            self.btnStartDate.setTitle(date, for: .normal)
            
        case 3:
            self.checkForShiftType()
            let date = self.dateSelected(self.datepickerView.date)
            self.endDate = self.datepickerView.date
            self.btnEndDate.setTitle(date, for: .normal)
            self.calculateDays()
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
    
    @IBAction func btnApplyAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let reason = self.trimString(self.textView.text ?? "")
        
        if !self.isValidText(reason) || reason == self.textViewPlaceholder{
            self.showAlert(title: "Warning", message: "Please enter reason for leave.", actionTitle: "Ok")
        }else if self.selectedShiftType == 3 && self.lblTotalDays.text?.contains("Duration") ?? false{
            self.showAlert(title: "Warning", message: "Please select end date.", actionTitle: "Ok")
        }else{
            self.apiHit()
        }
    }
    
    
    //MARK: - funcs
    func checkForShiftType(){
        let date = self.dateSelected(self.startDate)
        self.btnStartDate.setTitle(date, for: .normal)
        switch self.selectedShiftType{
        case 0 :
            self.viewDateHeight.constant = 77
            self.viewDate.isHidden = false
            self.btnEndDate.isUserInteractionEnabled = false
            self.btnEndDate.setTitleColor(themeColorLightGray, for: .normal)
            self.datepickerView.datePickerMode = .dateAndTime
            let maxiDate = Calendar.current.date(byAdding: .hour, value: 2, to: self.startDate) ?? Date()
            self.btnEndDate.setTitle(self.dateSelected(maxiDate), for: .normal)
            self.endDate = maxiDate
        case 1:
            self.viewDateHeight.constant = 77
            self.viewDate.isHidden = false
            self.btnEndDate.isUserInteractionEnabled = false
            self.btnEndDate.setTitleColor(themeColorLightGray, for: .normal)
            self.datepickerView.datePickerMode = .dateAndTime
            let maxiDate = Calendar.current.date(byAdding: .hour, value: 4, to: self.startDate) ?? Date()
            self.endDate = maxiDate
            self.btnEndDate.setTitle(self.dateSelected(maxiDate), for: .normal)
        case 2 :
            self.viewDateHeight.constant = 0
            self.viewDate.isHidden = true
            self.datepickerView.datePickerMode = .date
            self.btnEndDate.isUserInteractionEnabled = false
            self.datepickerView.maximumDate = nil
        case 3:
            self.viewDateHeight.constant = 77
            self.viewDate.isHidden = false
            self.btnEndDate.isUserInteractionEnabled = true
            self.btnEndDate.setTitleColor(themeColorDarkGray, for: .normal)
            self.datepickerView.datePickerMode = .dateAndTime
            self.endDate = Date()
            self.btnEndDate.setTitle("End Date (Including)", for: .normal)
        default:
            break
        }
        self.calculateDays()
    }
    
    func dateSelected(_ sender: Date) -> String {
        let formatter = DateFormatter()
        switch self.selectedShiftType{
        case 0,1,3: formatter.dateFormat = "dd MMM yyyy HH:mm a"
        case 2: formatter.dateFormat = "dd MMM yyyy"
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
        case 2: self.lblTotalDays.text = "Duration"
        case 3:
            let days = Calendar.current.dateComponents([.day], from: self.startDate, to: self.endDate).day ?? 0
            self.lblTotalDays.text = (days>0) ?  "\(days+1) Days" : "Duration"
        default: break
        }
    }
    
    
    //MARK:- API Hit
    private func apiHit(){
        let alert = UIAlertController(title: "Success", message: "Your have successfully applied for leave.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
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
            self.btnAttachment.setTitleColor(themeColorLink, for: .normal)
        }else if let img = info[.originalImage] as? UIImage{
            self.imageUploaded = img
            self.btnAttachment.setTitle(imageName, for: .normal)
            self.btnAttachment.setTitleColor(themeColorLink, for: .normal)
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
