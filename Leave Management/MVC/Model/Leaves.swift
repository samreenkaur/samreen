//
//  Leaves.swift
//  Leave Management
//
//  Created by osx on 19/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import Foundation
import RealmSwift

class LeavesModel: Object {
    
    //MARK:- Variables
    @objc dynamic var id = Int()
    @objc dynamic var userId = Int()
    @objc dynamic var shiftTypeId = Int()
    @objc dynamic var leaveStatusId = Int()
    @objc dynamic var leaveTypeId = Int()
    @objc dynamic var toDate: String = ""
    @objc dynamic var fromDate: String = ""
    @objc dynamic var toDateFormatted: String = ""
    @objc dynamic var fromDateFormatted: String = ""
    @objc dynamic var reason: String = ""
    @objc dynamic var documents: String = ""
    
    
    //MARK:- Main func
    override static func primaryKey() -> String? {
        return "id"
    }
    override static func ignoredProperties() -> [String] {
        return []
    }
    convenience init(dict : [String:AnyObject])
    {
        self.init()
        if let item = dict["Id"] as? Int
        {
            self.id = item
        }
        if let item = dict["UserId"] as? Int
        {
            self.userId = item
        }
        if let item = dict["ShiftTypeId"] as? Int
        {
            self.shiftTypeId = item
        }
        if let item = dict["LeaveStatusId"] as? Int
        {
            self.leaveStatusId = item
        }
        if let item = dict["LeaveTypeId"] as? Int
        {
            self.leaveTypeId = item
        }
        if let item = dict["ToDate"] as? String
        {
            self.toDate = item
        }
        if let item = dict["FromDate"] as? String
        {
            self.fromDate = item
        }
        if let item = dict["Reason"] as? String
        {
            self.reason = item
        }
        if let item = dict["Documents"] as? [[String: AnyObject]]
        {
            for i in item{
                if let ImageUrl = i["ImageUrl"] as? String
                {
                    self.documents = ImageUrl
                }
            }
        }
        formatDates()
    }
    
    func formatDates(){
        
        var formatter = "dd MMM yyyy HH:mm a"
        switch self.shiftTypeId{
            
        case 1,2,4:
            formatter = "dd MMM yyyy HH:mm a"
            break
        case 3:
            formatter = "dd MMM yyyy"
            break
        default: break
        }
        if !self.toDate.isEmpty
        {
            self.toDateFormatted = self.toDate.convertStringToDate(dataFormat: "yyyy-MM-dd'T'HH:mm:ss")?.convertDateToString(dataFormat: formatter) ?? ""
        }
        if !self.fromDate.isEmpty
        {
            self.fromDateFormatted = self.fromDate.convertStringToDate(dataFormat: "yyyy-MM-dd'T'HH:mm:ss")?.convertDateToString(dataFormat: formatter) ?? ""
        }
    }
}
