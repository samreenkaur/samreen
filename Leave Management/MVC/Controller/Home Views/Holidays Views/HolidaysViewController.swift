//
//  HolidaysViewController.swift
//  Leave Management
//
//  Created by osx on 05/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit

class HolidaysViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Variables
    var holidays = [HolidaysModel.init(dict: ["id":1 as AnyObject,"title":"Lohri" as AnyObject,"date":"13 01 2019" as AnyObject]),
                    HolidaysModel.init(dict: ["id":2 as AnyObject,"title":"Republic Day" as AnyObject,"date":"26 01 2019" as AnyObject]),
                    HolidaysModel.init(dict: ["id":3 as AnyObject,"title":"Holi" as AnyObject,"date":"21 03 2019" as AnyObject]),
                    HolidaysModel.init(dict: ["id":4 as AnyObject,"title":"Vaisakhi" as AnyObject,"date":"13 04 2019" as AnyObject]),
                    HolidaysModel.init(dict: ["id":5 as AnyObject,"title":"Good Friday" as AnyObject,"date":"19 04 2019" as AnyObject]),
                    HolidaysModel.init(dict: ["id":6 as AnyObject,"title":"Independence Day" as AnyObject,"date":"15 08 2019" as AnyObject]),
                    HolidaysModel.init(dict: ["id":7 as AnyObject,"title":"Diwali" as AnyObject,"date":"27 10 2019" as AnyObject]),
                    HolidaysModel.init(dict: ["id":8 as AnyObject,"title":"Christmas" as AnyObject,"date":"25 12 2019" as AnyObject])]
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
        //realm data
//        if let results = RealmDatabase.shared.fetch(type: HolidaysModel.self, AndFilter: nil)
//        {
//            self.holidaysArray = []
//            for i in results
//            {
//                if let model = i as? HolidaysModel
//                {
//                    self.holidaysArray.append(model)
//                }
//            }
//        }
//
        //get data and sort
        self.holidaysArray = self.holidays
//        self.holidaysArray = self.sortArray()
        let dict = Dictionary(grouping: self.holidaysArray, by: { $0.month })
        let sorted = dict.sorted { $0.key < $1.key }
//        let keysArraySorted = Array(sorted.map({ $0.key }))
        let valuesArraySorted = Array(sorted.map({ $0.value }))

        self.listArray = valuesArraySorted//new
        self.tableView.reloadData()
    }
    private func sortArray() -> [HolidaysModel]{
        dateFormatter.dateFormat = "dd MM, yyyy"
        let arr = self.holidaysArray.sorted(by: { dateFormatter.date(from:$0.completeDate)?.compare(dateFormatter.date(from:$1.completeDate) ?? Date()) == .orderedAscending })
        return arr
    }
    
    
    
    //MARK:- TableView Delegate and Datasources
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.listArray.count//12//
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listArray[section].count//2//
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
}
