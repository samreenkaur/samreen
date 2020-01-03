//
//  HolidaysViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit
import RealmSwift
import Alamofire


class HolidaysViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblNoData: UILabel!
    
    
    //MARK:- Variables
//    var holidays = [HolidaysModel.init(dict: ["id":1 as AnyObject,"title":"Lohri" as AnyObject,"date":"13 01 2019" as AnyObject]),
//                    HolidaysModel.init(dict: ["id":2 as AnyObject,"title":"Republic Day" as AnyObject,"date":"26 01 2019" as AnyObject]),
//                    HolidaysModel.init(dict: ["id":3 as AnyObject,"title":"Holi" as AnyObject,"date":"21 03 2019" as AnyObject]),
//                    HolidaysModel.init(dict: ["id":4 as AnyObject,"title":"Vaisakhi" as AnyObject,"date":"13 04 2019" as AnyObject]),
//                    HolidaysModel.init(dict: ["id":5 as AnyObject,"title":"Good Friday" as AnyObject,"date":"19 04 2019" as AnyObject]),
//                    HolidaysModel.init(dict: ["id":6 as AnyObject,"title":"Independence Day" as AnyObject,"date":"15 08 2019" as AnyObject]),
//                    HolidaysModel.init(dict: ["id":7 as AnyObject,"title":"Diwali" as AnyObject,"date":"27 10 2019" as AnyObject]),
//                    HolidaysModel.init(dict: ["id":8 as AnyObject,"title":"Guru Nanak Dev Ji's Birthday" as AnyObject,"date":"12 11 2019" as AnyObject]),
//                    HolidaysModel.init(dict: ["id":9 as AnyObject,"title":"Christmas" as AnyObject,"date":"25 12 2019" as AnyObject]),
//                    HolidaysModel.init(dict: ["id":10 as AnyObject,"title":"Krishna Janmashtami" as AnyObject,"date":"24 08 2019" as AnyObject])]
    var holidaysArray = [HolidaysModel]()
    var listArray = [[HolidaysModel]]()
    
    //MARK:- Lifecycle func
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpNavigationBar()
        self.callViewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.callViewWillAppear()
    }
    
    
    //MARK:- main funcs
    private func callViewDidLoad()
    {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.getUserData()
    }
    private func callViewWillAppear()
    {
        self.getList()
    }
    
    private func setUpNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.navigationItem.title = "Holidays"
    }
    
    //MARK:- funcs
    private func getList(){
        
        //get data and sort
        self.listArray = []
        self.holidaysArray = self.getHolidaysModelFromRealm()
        self.sortList()
        self.apiHit()
    }
    func sortList(){
        
        let sorted = self.holidaysArray.sorted { $0.date?.compare($1.date ?? Date()) == .orderedAscending }
        var last = HolidaysModel()
        for i in sorted
        {
            if i.month == last.month && i.year == last.year
            {
                self.listArray[self.listArray.count - 1].append(i)
                last = i
            }else{
                self.listArray.append([i])
                last = i
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
    }
    
    
    
    
    //MARK:- TableView Delegate and Datasources
    func numberOfSections(in tableView: UITableView) -> Int {
        let count = self.listArray.count
        if count > 0 {
            self.lblNoData.isHidden = true
            self.tableView.isHidden = false
        }else{
            self.lblNoData.isHidden = false
            self.tableView.isHidden = true
        }
        return count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArray[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: kHolidaysTableViewCell, for: indexPath) as! HolidaysTableViewCell
        let data = self.listArray[indexPath.section][indexPath.row]
        cell.lbltitle.text = data.title
        cell.lblDay.text = "\(data.day)"
        return cell
    }
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "\(section) - 2019"
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: 30)) //set these values as necessary
        returnedView.backgroundColor = .white
        
        let label = UILabel(frame: CGRect(x: 20, y: 5, width: self.tableView.frame.width - 40, height: 30))
        label.font = .boldSystemFont(ofSize: 14)
        label.textColor = UIColor.black
//        label.text = "\(section+1) - 2019"
        let data = self.listArray[section][0]
        let month: String = "\(Month.init(rawValue: data.month)!)"
        label.text = "\(month) \(data.year)"
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    //MARK:- API Hit
    private func apiHit(){
        
        
        self.getHolidaysListApiHit(showLoader: (self.listArray.count>0) ? false :  true) { (modelArr) in
            self.listArray = []
            self.holidaysArray = modelArr
            self.sortList()
        }
        
        
//        let url = APIUrl.base + APIUrl.getAllHolidays
//        let parameters : Parameters = [:]
//
//        let headers: HTTPHeaders = ["Authorization": user.tokenType + " " + user.accessToken]
//
//        if listArray.count <= 0
//        {
//            self.addLoader()
//        }
//        print("\n\n\nAPI::: \(url) \nParamteres::: \(parameters) \nHeaders::: \(headers)")
//        Alamofire.request(url, method: .get, parameters: parameters,encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
//            switch response.result
//            {
//            case .success(_):
//                self.removeLoader()
//                if let data = response.result.value as? [String:AnyObject]
//                {
//                    self.removeLoader()
//                    let responseData = ResponseModel.init(data)
//                    if responseData.success == 1
//                    {
//                        let model : [HolidaysModel] = responseData.dataArray.map(HolidaysModel.init)
////                        model.append(HolidaysModel.init(dict: ["Name":"Republic Day" as AnyObject,"Date":"2020-01-26T00:00:00" as AnyObject]))
////                        model.append(HolidaysModel.init(dict: ["Name":"Republic Day" as AnyObject,"Date":"2018-01-26T00:00:00" as AnyObject]))
//                        self.listArray = []
//                        self.holidaysArray = model
//                        self.sortList()
//                        self.saveHolidaysModelToRealm(model: model)
//                    }
//                    else if responseData.sessionExpired
//                    {
//                        self.refreshTokenApiHit()
//                    }
//                    else
//                    {
//                        self.showAlert(title: "Error", message: responseData.errorMessage, actionTitle: "Ok")
//                    }
//
//                }
//                else
//                {
//                    self.showAlert(title: "Error", message: "", actionTitle: "Ok")
//                }
//            case .failure(let error):
//                self.removeLoader()
//                print(error.localizedDescription)
//                self.showAlert(title: "Error", message: error.localizedDescription, actionTitle: "Ok")
//            }
//        }
    }
    
    
    
}
