//
//  Notifications.swift
//  Leave Management
//
//  Created by osx on 23/12/19.
//  Copyright © 2019 osx. All rights reserved.
//

import Foundation
import RealmSwift

class NotificationsModel: Object {
    
    //MARK:- Variables
    @objc dynamic var id = Int()
    @objc dynamic var title: String = ""
    @objc dynamic var time: String = ""
    
    
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
        if let item = dict["id"] as? Int
        {
            self.id = item
        }
        if let item = dict["Name"] as? String
        {
            self.title = item
        }
        if let item = dict["Time"] as? String
        {
            if item != ""{
                let date = item.convertStringToDate(dataFormat: "yyyy-MM-dd'T'HH:mm:ss")
                let component = Calendar.current.dateComponents([.day,.month,.year], from: date!, to: Date())
                
                if component.year ?? 0 > 1
                {
                    self.time = date?.convertDateToString(dataFormat: "dd-MM-yyyy") ?? ""
                }else if component.month ?? 0 > 1
                {
                    self.time = date?.convertDateToString(dataFormat: "HH:mm a dd-MMM ") ?? ""
                }else if component.day ?? 0 > 1
                {
                    self.time = date?.convertDateToString(dataFormat: "HH:mm a dd-MMM ") ?? ""
                }else if component.hour ?? 0 > 1
                {
                    self.time = date?.convertDateToString(dataFormat: "HH:mm a") ?? ""
                }else if component.minute ?? 0 > 1
                {
                    self.time = "\(component.minute ?? 0) minutes ago"
                }else if component.second ?? 0 > 1
                {
                    self.time = "Just now"
                }
                
            }
        }
    }
    
    
    
}
